#!/usr/bin/env bash
# OURCODE decoder
# Usage:
#   chmod +x decode_md.sh
#   ./decode_md.sh input_safe.txt output.md
# Notes:
# - If output.md is omitted, the script edits input_safe.txt in-place.
# - GNU sed syntax (-i). On macOS use: sed -i '' ...

set -euo pipefail

input="${1:-}"
output="${2:-}"

if [[ -z "$input" ]]; then
  echo "Usage: $0 input_safe.md [output.md]" >&2
  exit 1
fi

if [[ ! -f "$input" ]]; then
  echo "Error: input file not found: $input" >&2
  exit 1
fi

# Work on a copy if output is provided; otherwise edit in-place.
tmp="$input"
if [[ -n "$output" ]]; then
  cp -- "$input" "$output"
  tmp="$output"
fi

# Headings
sed -i 's/@@H1@@/# /g'  "$tmp"
sed -i 's/@@H1_END@@//g' "$tmp"
sed -i 's/@@H2@@/## /g' "$tmp"
sed -i 's/@@H2_END@@//g' "$tmp"
sed -i 's/@@H3@@/### /g' "$tmp"
sed -i 's/@@H3_END@@//g' "$tmp"

# Paragraphs
sed -i 's/@@P@@//g' "$tmp"
sed -i 's/@@P_END@@//g' "$tmp"

# Bold
sed -i 's/@@BOLD@@/**/g' "$tmp"
sed -i 's/@@BOLD_END@@/**/g' "$tmp"

# Inline code
sed -i 's/@@CODE@@/`/g' "$tmp"
sed -i 's/@@CODE_END@@/`/g' "$tmp"

# List items
sed -i 's/@@LIST_ITEM@@/- /g' "$tmp"
sed -i 's/@@LIST_ITEM_END@@//g' "$tmp"

# Code blocks (open fences)
sed -i 's/@@CODEBLOCK_JAVA@@/```java/g' "$tmp"
sed -i 's/@@CODEBLOCK_TEXT@@/```text/g' "$tmp"
sed -i 's/@@CODEBLOCK_BASH@@/```bash/g' "$tmp"

# Code blocks (close fences) — only once
sed -i 's/@@CODEBLOCK_END@@/```/g' "$tmp"

# Notes → GitHub-style admonitions
sed -i 's/@@NOTE@@/> **Note:** /g' "$tmp"
sed -i 's/@@NOTE_END@@//g' "$tmp"

echo "Decoded OURCODE → Markdown: $tmp"



