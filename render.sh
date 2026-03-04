#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Rendering site to docs/..."
quarto render

echo "Rendering syllabus PDF..."
quarto render course_docs/syllabus.qmd --to pdf --output-dir docs/course_docs

echo "Rendering demo 2/3 (tools-introduction) worked notebooks..."
bash demos/2-tools-introduction/render.sh

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

echo "Copying demo 4-8 assets..."
for demo_dir in demos/4-vscode-gui-agent demos/5-git-push-pull demos/6-tmux-workflow demos/7-phi-two-machine demos/8-context-comparison; do
  name="$(basename "$demo_dir")"
  dst="docs/demos/$name"
  mkdir -p "$dst"
  # Copy any non-qmd assets (images, data files, etc.) that quarto render doesn't handle
  find "$demo_dir" -maxdepth 2 -type f ! -name '*.qmd' ! -name '*.html' -exec cp --parents {} docs/ \; 2>/dev/null || true
done

echo "Done. Output in docs/"
