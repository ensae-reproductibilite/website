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

# Fetch latest updates
echo -e "${YELLOW}Fetching latest updates...${NC}"
git fetch --all --tags

# Ensure the tag exists
if ! git rev-parse "$TAG" >/dev/null 2>&1; then
  echo -e "${RED}Error: Tag '$TAG' not found.${NC}"
  exit 1
fi

# Create a backup branch from the current main state
echo -e "${YELLOW}Creating backup branch '$BACKUP_BRANCH'...${NC}"
git checkout "$MAIN_BRANCH"
git checkout -b "$BACKUP_BRANCH"
git push origin "$BACKUP_BRANCH"
echo -e "${GREEN}Backup branch '$BACKUP_BRANCH' created.${NC}"

# Overwrite main with the tag
echo -e "${YELLOW}Resetting '$MAIN_BRANCH' to '$TAG'...${NC}"
git branch -f "$MAIN_BRANCH" "$TAG"

# Checkout main
git checkout "$MAIN_BRANCH"

# Push the new main branch to remote
# Uncomment the line below to actually push the changes
# git push origin "$MAIN_BRANCH" --force

echo -e "${GREEN}Successfully reset '$MAIN_BRANCH' to tag '$TAG'.${NC}"
echo -e "If you want to update your remote counterpart, use ${RED}git push origin "$MAIN_BRANCH" --force${NC}"
