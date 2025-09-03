#!/usr/bin/env bash
set -euo pipefail


# Convert all docs/*.md into slides/*.pdf using pandoc.
# Requires: pandoc. For best results, install a LaTeX engine (xelatex) too.


ROOT_DIR="$(cd "$(dirname "$0")"/.. && pwd)"
DOCS_DIR="$ROOT_DIR/docs"
OUT_DIR="$ROOT_DIR/slides"


mkdir -p "$OUT_DIR"


if ! command -v pandoc >/dev/null 2>&1; then
echo "Error: pandoc not found. Install pandoc and retry." >&2
exit 1
fi


ENGINE_ARG=()
if command -v xelatex >/dev/null 2>&1; then
ENGINE_ARG=(--pdf-engine=xelatex -V mainfont="DejaVu Serif" -V monofont="DejaVu Sans Mono")
fi


shopt -s nullglob
for md in "$DOCS_DIR"/*.md; do
base="$(basename "$md" .md)"
pdf="$OUT_DIR/$base.pdf"
echo "[pandoc] $md -> $pdf"
pandoc "$md" -o "$pdf" \
${ENGINE_ARG[@]} \
-V geometry:margin=1in \
--toc
done