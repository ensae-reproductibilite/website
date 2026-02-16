#!/bin/bash
set -e

TAG=$1
[ -z "$TAG" ] && { echo "Usage: $0 <tag>"; exit 1; }

UPSTREAM=https://github.com/ensae-reproductibilite/application.git
REMOTE_TMP=upstream

# Stash local changes (including untracked)
git stash push -u

# Fetch correction tags
if ! git remote get-url $REMOTE_TMP >/dev/null 2>&1; then
  git remote add $REMOTE_TMP $UPSTREAM
fi
git fetch $REMOTE_TMP --tags --force

# Ensure tag exists
git rev-parse "$TAG" >/dev/null 2>&1 || { echo "Tag $TAG not found"; exit 1; }

# Reset main safely
git checkout -B main
git reset --hard "$TAG"
git push origin main --force-with-lease

echo "Checkpoint '$TAG' applied."
