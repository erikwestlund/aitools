#!/usr/bin/env bash
# Render worked notebooks for the tools-introduction demo.
# Renders each .qmd, then moves the HTML into rendered_notebooks/.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKED_DIR="$SCRIPT_DIR/worked"
OUT_DIR="$SCRIPT_DIR/rendered_notebooks"

mkdir -p "$OUT_DIR"

# Accept specific files or default to all .qmd in worked/
if [ $# -gt 0 ]; then
  files=("$@")
else
  files=("$WORKED_DIR"/*.qmd)
fi

for qmd in "${files[@]}"; do
  name="$(basename "$qmd" .qmd)"
  echo "--- Rendering: $name ---"
  quarto render "$qmd"
  # Move output to rendered_notebooks/
  if [ -f "$WORKED_DIR/$name.html" ]; then
    mv "$WORKED_DIR/$name.html" "$OUT_DIR/$name.html"
    echo "    -> $OUT_DIR/$name.html"
  fi
done
