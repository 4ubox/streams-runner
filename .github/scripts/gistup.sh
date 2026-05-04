#!/bin/bash

# Exit immediately on error
set -e

# Check if GitHub CLI is installed
if ! command -v gh > /dev/null 2>&1; then
  echo "Error: gh (GitHub CLI) is not installed."
  exit 1
fi

# Check required environment variables
if [ -z "$GIST_TOKEN" ]; then
  echo "Error: GIST_TOKEN is not set."
  exit 1
fi

if [ -z "$GIST_ID" ]; then
  echo "Error: GIST_ID is not set."
  exit 1
fi

# Authenticate non-interactively
export GH_TOKEN="$GIST_TOKEN"
# echo "$GH_TOKEN" | gh auth login --with-token

# Push updates to gist
set -- $(find . -maxdepth 1 -type f -print0)
echo "$GIST_ID" "$@"
gh gist edit "$GIST_ID" "$@"

# args=()
# while IFS= read -r file; do
# args+=("$file")
# done < <(find . -maxdepth 1 -type f)

# echo $args

# gh gist edit "$GIST_ID" "${args[@]}"

echo "Gist updated successfully."
