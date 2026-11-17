#!/bin/bash
# Usage : ./update.sh <tag> [application|application-deployment]
# Remet le dépôt local dans l'état attendu après une étape (ex. appli25).
#
# Le dépôt de correction est choisi d'après le nom de votre dépôt local
# (application ou application-deployment), sauf si vous le précisez en 2e argument.
# Pour les tests, CHECKPOINT_UPSTREAM remplace l'URL de la correction.
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

# Valeurs à personnaliser (on affiche seulement, on ne modifie rien)
PLACEHOLDERS='<(GITHUB_USERNAME|DOCKERHUB_USERNAME|SSPCLOUD_USERNAME|APP_NAME)>'
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
    case $m in
      '<GITHUB_USERNAME>') echo "  <GITHUB_USERNAME> : votre compte GitHub" ;;
      '<DOCKERHUB_USERNAME>') echo "  <DOCKERHUB_USERNAME> : votre compte DockerHub" ;;
      '<SSPCLOUD_USERNAME>') echo "  <SSPCLOUD_USERNAME> : votre identifiant SSP Cloud (namespace user-..., bucket S3)" ;;
      '<APP_NAME>') echo "  <APP_NAME> : un nom unique pour l'URL de votre API, ex. dvf-<prenom>" ;;
    esac
  done <<< "$FOUND"
  echo
fi

echo "Checkpoint '$TAG' appliqué."
