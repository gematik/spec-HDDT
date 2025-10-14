#!/usr/bin/env sh
set -eu

# Usage check
if [ "${1:-}" = "" ]; then
  printf "Usage: %s path/to/file.md\n" "$(basename "$0")" >&2
  exit 1
fi

# Require Ruby
if ! command -v ruby >/dev/null 2>&1; then
  echo "Ruby not found. Please install Ruby and try again." >&2
  exit 1
fi

# Resolve script directory (works with symlinks too)
# shellcheck disable=SC3000-SC4000
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"

SCRIPT="$SCRIPT_DIR/_markdownConventions.rb"
if [ ! -f "$SCRIPT" ]; then
  echo "Missing: $SCRIPT" >&2
  exit 1
fi

ruby "$SCRIPT" "$1"
