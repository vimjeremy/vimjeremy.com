#!/bin/bash
# Copies your Obsidian posts into the Hugo site.
#
# Usage:
#   ./sync-posts.sh            copy for real
#   ./sync-posts.sh --dry-run  only show what WOULD change, copy nothing

# Stop at the first error, and treat unset variables as errors.
set -euo pipefail

# Where your posts live in Obsidian (the trailing / matters, see below).
SOURCE="/Users/jeremy/Documents/brain/blog-posts/"

# Where Hugo reads posts from: "content/posts" next to this script.
# $(dirname "$0") is the folder this script is in, so it works from anywhere.
DEST="$(cd "$(dirname "$0")" && pwd)/content/posts/"

# Refuse to run if the source folder is missing. Otherwise --delete below would
# make the destination match an empty folder and wipe all your posts.
if [ ! -d "$SOURCE" ]; then
  echo "Error: can't find $SOURCE" >&2
  exit 1
fi

mkdir -p "$DEST"

# -a  archive: copy folders recursively and keep timestamps
# -v  verbose: list each file that is copied or removed
# --delete  remove files from DEST that are no longer in SOURCE (a true mirror)
# --exclude  skip Obsidian's hidden settings folder and macOS junk files
# "$@"  passes along anything you typed after the script name, like --dry-run
rsync -av --delete \
  --exclude='.obsidian' \
  --exclude='.DS_Store' \
  "$@" \
  "$SOURCE" "$DEST"

echo "Done."
