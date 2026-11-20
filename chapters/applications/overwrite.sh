#!/bin/bash
# Usage : ./update.sh <tag> [application|application-deployment]
# Remet le dépôt local dans l'état attendu après une étape (ex. appli25).
#
# Le dépôt de correction est choisi d'après le nom de votre dépôt local
# (application ou application-deployment), sauf si vous le précisez en 2e argument.
# Pour les tests, CHECKPOINT_UPSTREAM remplace l'URL de la correction.
#
# Si un terminal est disponible, le script vous demande les valeurs à remplacer
# (<GITHUB_USERNAME>, <DOCKERHUB_USERNAME>, <SSPCLOUD_USERNAME>, <APP_NAME>) :
# Entrée accepte la valeur proposée entre crochets, ou passe la valeur.
# Sans terminal (CI, entrée non interactive), le script se contente de lister
# les valeurs à remplacer.
set -e

TAG=$1
[ -z "$TAG" ] && { echo "Usage: $0 <tag> [application|application-deployment]"; exit 1; }

# Nom du dépôt local : basename de l'URL origin, sans .git ni /
ORIGIN=$(git remote get-url origin 2>/dev/null || true)
ORIGIN=${ORIGIN%/}
ORIGIN=${ORIGIN%.git}
REPO=${2:-$(basename "$ORIGIN")}

BASE=https://github.com/ensae-reproductibilite
if [ "$REPO" = "application-deployment" ]; then
  UPSTREAM=$BASE/application-deployment.git
else
  UPSTREAM=$BASE/application.git
fi
UPSTREAM=${CHECKPOINT_UPSTREAM:-$UPSTREAM}
echo "Correction utilisée : $UPSTREAM"

REMOTE_TMP=upstream

# Stash local changes (including untracked)
git stash push -u

# Fetch correction tags (l'URL de la remote upstream est mise à jour si besoin)
CURRENT=$(git remote get-url $REMOTE_TMP 2>/dev/null || true)
if [ -z "$CURRENT" ]; then
  git remote add $REMOTE_TMP "$UPSTREAM"
elif [ "$CURRENT" != "$UPSTREAM" ]; then
  git remote set-url $REMOTE_TMP "$UPSTREAM"
fi
git fetch $REMOTE_TMP --tags --force

# Vérifie que le tag existe dans la correction (et pas seulement en local)
if ! git ls-remote --exit-code --tags $REMOTE_TMP "refs/tags/$TAG" >/dev/null 2>&1; then
  echo "Le tag '$TAG' n'existe pas dans $UPSTREAM."
  echo "Cette étape n'a peut-être pas de checkpoint pour ce dépôt."
  exit 1
fi

# Reset main safely
git checkout -B main
git reset --hard "$TAG"

PLACEHOLDERS='<(GITHUB_USERNAME|DOCKERHUB_USERNAME|SSPCLOUD_USERNAME|APP_NAME)>'
PLACEHOLDER_NAMES="GITHUB_USERNAME DOCKERHUB_USERNAME SSPCLOUD_USERNAME APP_NAME"
REPLACED=0

# Légende d'une valeur à personnaliser
legend() {
  case $1 in
    GITHUB_USERNAME) echo "votre compte GitHub" ;;
    DOCKERHUB_USERNAME) echo "votre compte DockerHub" ;;
    SSPCLOUD_USERNAME) echo "votre identifiant SSP Cloud, sans le préfixe user- (ex. prenom-nom)" ;;
    APP_NAME) echo "un nom unique pour l'URL de votre API, ex. dvf-<prenom>" ;;
  esac
}

# Valeur proposée par défaut, si on peut la deviner (sinon rien)
guess_default() {
  local ns re
  case $1 in
    GITHUB_USERNAME)
      # Propriétaire du dépôt, si l'origine est sur github.com (https ou ssh)
      re='^(https?://([^@/]+@)?github\.com/|git@github\.com:)([^/:]+)/'
      # (sauf le dépôt du cours, cloné sans fork)
      if [[ $ORIGIN =~ $re ]] && [ "${BASH_REMATCH[3]}" != "ensae-reproductibilite" ]; then
        echo "${BASH_REMATCH[3]}"
      fi
      ;;
    SSPCLOUD_USERNAME)
      # Namespace Kubernetes personnel (user-prenom-nom), sans le préfixe user-.
      # Un namespace de projet (projet-...) ne donne pas d'identifiant.
      ns=${KUBERNETES_NAMESPACE:-}
      if [ -z "$ns" ] && [ -r /var/run/secrets/kubernetes.io/serviceaccount/namespace ]; then
        ns=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>/dev/null || true)
      fi
      if [[ $ns =~ ^user-([A-Za-z0-9._-]+)$ ]]; then echo "${BASH_REMATCH[1]}"; fi
      ;;
  esac
}

# Remplace <NAME> par la valeur dans les fichiers suivis (hors notebooks)
replace_placeholder() {
  local name=$1 value=$2 files file count=0
  files=$(git grep -lF "<$name>" -- ':!*.ipynb' || true)
  while IFS= read -r file; do
    [ -n "$file" ] || continue
    sed -i "s|<$name>|$value|g" -- "$file"
    count=$((count + 1))
  done <<< "$files"
  echo "✔ <$name> remplacé par $value dans $count fichier(s)"
  REPLACED=1
}

# Demande une valeur à l'étudiant (lue sur le terminal, fd 3) ; Entrée = passer
ask_value() {
  local name=$1 default answer prompt
  default=$(guess_default "$name")
  prompt="Valeur pour <$name>"
  if [ -n "$default" ]; then
    prompt+=" [$default] (Entrée pour accepter) : "
  else
    prompt+=" (Entrée pour passer) : "
  fi
  while :; do
    printf '%s' "$prompt" >&2
    if ! IFS= read -r -u 3 answer; then
      echo >&2
      return 0
    fi
    answer=${answer:-$default}
    if [ -z "$answer" ]; then
      return 0
    fi
    if [[ $answer =~ ^[A-Za-z0-9._-]+$ ]]; then
      replace_placeholder "$name" "$answer"
      return 0
    fi
    echo "Valeur invalide : '$answer'. Seuls les lettres, chiffres, '.', '_' et '-' sont autorisés." >&2
  done
}

# Ouverture du terminal (absent en CI ou hors terminal : pas de question posée)
TTY_OK=0
if [ -r /dev/tty ] && (exec 3</dev/tty) 2>/dev/null; then
  exec 3</dev/tty
  TTY_OK=1
fi

if [ "$TTY_OK" = 1 ]; then
  for name in $PLACEHOLDER_NAMES; do
    files=$(git grep -lF "<$name>" -- ':!*.ipynb' || true)
    [ -n "$files" ] || continue
    nfiles=$(printf '%s\n' "$files" | wc -l)
    noccur=$(git grep -hoF "<$name>" -- ':!*.ipynb' | wc -l)
    echo
    echo "<$name> : $(legend "$name")"
    echo "  $noccur occurrence(s) dans $nfiles fichier(s)"
    ask_value "$name"
  done
  echo
fi

# Valeurs restant à personnaliser (on affiche seulement, on ne modifie rien)
MATCHES=$(git grep -nE "$PLACEHOLDERS" -- ':!*.ipynb' || true)

if [ -n "$MATCHES" ]; then
  echo "⚠ Valeurs à personnaliser avant de pousser :"
  while IFS= read -r line; do
    file=${line%%:*}
    rest=${line#*:}
    num=${rest%%:*}
    content=${rest#*:}
    markers=$(printf '%s\n' "$content" | grep -oE "$PLACEHOLDERS" | sort -u | paste -sd' ' -)
    text=$(printf '%s' "$content" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    [ ${#text} -gt 100 ] && text="${text:0:100}…"
    echo "  $file:$num  $markers  $text"
  done <<< "$MATCHES"

  echo
  echo "Légende :"
  FOUND=$(printf '%s\n' "$MATCHES" | grep -oE "$PLACEHOLDERS" | sort -u)
  while IFS= read -r m; do
    name=${m#<}
    name=${name%>}
    echo "  $m : $(legend "$name")"
  done <<< "$FOUND"
  echo
fi

echo "Checkpoint '$TAG' appliqué."

if [ "$REPLACED" = 1 ]; then
  echo "⚠ Des fichiers ont été modifiés par vos réponses : validez-les (git add / git commit) avant de pousser."
fi
