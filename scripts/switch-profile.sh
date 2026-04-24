#!/usr/bin/env bash
set -euo pipefail

PROFILE_NAME="${1:-}"
if [ -z "$PROFILE_NAME" ]; then
  echo "Usage: switch-profile <profile-name>" >&2
  exit 1
fi

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/cabanashmul"
RESULT_LINK="$DATA_DIR/result-$PROFILE_NAME"

if [ ! -e "$RESULT_LINK" ]; then
  echo "switch-profile: no pre-built result for '$PROFILE_NAME'" >&2
  echo "Run build-profiles from your cabanashmul directory first." >&2
  exit 1
fi

echo "Activating profile: $PROFILE_NAME"
exec "$RESULT_LINK/activate"
