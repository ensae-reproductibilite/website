"""Génère la liste des projets de la galerie depuis chapters/galerie/projets.yml.

Lancé par Quarto avant chaque rendu (pre-render). Écrit un fichier plat,
utilisable comme `contents` d'un listing, sans le réécrire si rien n'a changé.
"""

import os
import re
import sys
from pathlib import Path

import yaml

PARCOURS = ["MLOps", "Dashboard / app", "Big data", "Publication"]
REPO_RE = re.compile(r"^[\w.-]+/[\w.-]+$")
HEADER = "# Fichier généré par scripts/galerie.py depuis projets.yml : ne pas éditer.\n"

ROOT = Path(os.environ.get("QUARTO_PROJECT_DIR") or Path(__file__).resolve().parent.parent)
SOURCE = ROOT / "chapters" / "galerie" / "projets.yml"
TARGET = ROOT / "chapters" / "galerie" / "projets-listing.yml"


def fail(message):
    print(f"galerie.py : erreur : {message}", file=sys.stderr)
    sys.exit(1)


def check(year, entry):
    if not isinstance(entry, dict):
        fail(f"année {year} : une entrée n'est pas un dictionnaire")
    repo = entry.get("repo")
    where = f"année {year}, dépôt {repo or entry.get('title', '?')}"
    if not repo or not REPO_RE.match(str(repo)):
        fail(f"{where} : 'repo' obligatoire, de la forme owner/name")
    if not entry.get("title"):
        fail(f"{where} : 'title' manquant")
    if entry.get("parcours") not in PARCOURS:
        fail(f"{where} : parcours {entry.get('parcours')!r} inconnu (attendu : {', '.join(PARCOURS)})")
    description = entry.get("description") or {}
    for lang in ("fr", "en"):
        if not description.get(lang):
            fail(f"{where} : description.{lang} manquante")


def build(data):
    items = []
    for year, entries in data.items():
        if not isinstance(year, int):
            fail(f"clé d'année invalide : {year!r}")
        for entry in entries or []:
            check(year, entry)
            item = {
                "title": entry["title"],
                "year": year,
                "categories": [entry["parcours"]],
                "stack": entry.get("stack") or [],
                "description-fr": entry["description"]["fr"],
                "description-en": entry["description"]["en"],
                "github": f"https://github.com/{entry['repo']}",
            }
            if entry.get("website"):
                item["website"] = entry["website"]
            items.append(item)
    return items


def main():
    data = yaml.safe_load(SOURCE.read_text(encoding="utf-8")) or {}
    items = build(data)
    content = HEADER + yaml.safe_dump(
        items, allow_unicode=True, sort_keys=False, width=float("inf")
    )
    if TARGET.exists() and TARGET.read_text(encoding="utf-8") == content:
        return
    TARGET.write_text(content, encoding="utf-8")
    print(f"galerie.py : {len(items)} projets écrits dans {TARGET.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
