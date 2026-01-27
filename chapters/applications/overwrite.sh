#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

echo -e "${BLUE}...........................${NC}"
echo -e "${BLUE}  APPLICATION CHECKPOINT   ${NC}"
echo -e "${BLUE}...........................${NC}"

# Ensure a tag name is provided
if [ -z "$1" ]; then
  echo -e "${RED}Usage: $0 <tag>${NC}"
  exit 1
fi

TAG=$1
MAIN_BRANCH="main"
BACKUP_BRANCH="dev_before_${TAG}"
FORK_REMOTE="https://github.com/ensae-reproductibilite/application.git"

# Get the current remote URL
CURRENT_REMOTE=$(git remote get-url origin)

# Check if the origin is not the fork repo
if [ "$CURRENT_REMOTE" != "$FORK_REMOTE" ]; then
  echo -e "${YELLOW}Adding 'fork' remote to fetch latest tags...${NC}"

  # Add fork as a temporary remote
  git remote add fork "$FORK_REMOTE"

  echo -e "${GREEN}Remote 'fork' added.${NC}"
fi

# Fetch latest updates from the fork (for tags)
echo -e "${YELLOW}Fetching latest updates from fork...${NC}"
git fetch fork --tags --force

# Ensure the tag exists in either origin or fork
if ! git rev-parse "$TAG" >/dev/null 2>&1; then
  echo -e "${RED}Error: Tag '$TAG' not found.${NC}"

  # Remove the fork remote if it was added
  if git remote get-url fork >/dev/null 2>&1; then
    git remote remove fork
    echo -e "${YELLOW}Removed temporary 'fork' remote.${NC}"
  fi

  exit 1
fi

# Remove the temporary 'fork' remote if it was added
if git remote get-url fork >/dev/null 2>&1; then
  git remote remove fork
  echo -e "${YELLOW}Removed temporary 'fork' remote.${NC}"
fi

# Check if the backup branch already exists
if git rev-parse --verify "$BACKUP_BRANCH" >/dev/null 2>&1; then
  git branch -D "$BACKUP_BRANCH"
else
  echo -e "${YELLOW}Branch $BACKUP_BRANCH does not exist, creating a new one.${NC}"
fi

# Create a backup branch from the current main state
echo -e "${YELLOW}Creating backup branch '$BACKUP_BRANCH'...${NC}"

git reset --hard
git checkout "$MAIN_BRANCH"
git checkout -b "$BACKUP_BRANCH"
echo -e "${GREEN}Backup branch '$BACKUP_BRANCH' created.${NC}"

# Overwrite main with the tag
echo -e "${YELLOW}Resetting '$MAIN_BRANCH' to '$TAG'...${NC}"
git branch -f "$MAIN_BRANCH" "$TAG"

# Checkout main
git checkout "$MAIN_BRANCH"

# Push the new main branch to remote
# Uncomment the line below to actually push the changes

echo -e "${GREEN}Successfully reset '$MAIN_BRANCH' to tag '$TAG'.${NC}"
#echo -e "If you want to update your remote counterpart, use ${BLUE}git push origin "$MAIN_BRANCH" --force${NC}"
