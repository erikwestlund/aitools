#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Rendering site to docs/..."
quarto render

echo "Rendering syllabus PDF..."
quarto render course_docs/syllabus.qmd --to pdf --output-dir docs/course_docs

echo "Copying demo 2 (tools-introduction) notebooks and summary..."
DEMO2_SRC="demos/2-tools-introduction"
DEMO2_DST="docs/demos/2-tools-introduction"
mkdir -p "$DEMO2_DST/rendered_notebooks"
if [ -f "$DEMO2_SRC/summary.html" ]; then
  cp "$DEMO2_SRC/summary.html" "$DEMO2_DST/summary.html"
fi
if [ -d "$DEMO2_SRC/rendered_notebooks" ]; then
  cp "$DEMO2_SRC/rendered_notebooks/"*.html "$DEMO2_DST/rendered_notebooks/"
fi

echo "Done. Output in docs/"
