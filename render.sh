#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Rendering all .qmd files..."
quarto render

echo "Rendering syllabus PDF..."
quarto render course_docs/syllabus.qmd --to pdf --output-dir ../docs
echo "Done. Output in docs/"
