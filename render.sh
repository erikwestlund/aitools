#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Rendering site to docs/..."
quarto render

echo "Rendering syllabus PDF..."
quarto render course_docs/syllabus.qmd --to pdf --output-dir docs/course_docs

echo "Done. Output in docs/"
