#!/usr/bin/env bash
# OURCODE
# Usage: chmod +x decode_md.sh ./decode_md.sh input_safe.md output.md
# Converts placeholder code tags into real Markdown fences.

input="$1"

# Headings
sed -i 's/@@H1@@/# /g' "$input"
sed -i 's/@@H1_END@@//g' "$input"
sed -i 's/@@H2@@/## /g' "$input"
sed -i 's/@@H2_END@@//g' "$input"
sed -i 's/@@H3@@/### /g' "$input"
sed -i 's/@@H3_END@@//g' "$input"

# Paragraphs
sed -i 's/@@P@@//g' "$input"
sed -i 's/@@P_END@@//g' "$input"

# Bold
sed -i 's/@@BOLD@@/**/g' "$input"
sed -i 's/@@BOLD_END@@/**/g' "$input"

# Inline code
sed -i 's/@@CODE@@/`/g' "$input"
sed -i 's/@@CODE_END@@/`/g' "$input"

# List items
sed -i 's/@@LIST_ITEM@@/- /g' "$input"
sed -i 's/@@LIST_ITEM_END@@//g' "$input"

# Code blocks
sed -i 's/@@CODEBLOCK_JAVA@@/```java/g' "$input"
sed -i 's/@@CODEBLOCK_END@@/```/g' "$input"

# Code blocks
sed -i 's/@@CODEBLOCK_TEXT@@/```text/g' "$input"
sed -i 's/@@CODEBLOCK_END@@/```/g' "$input"

# Notes → GitHub-style admonitions
sed -i 's/@@NOTE@@/> **Note:** /g' "$input"
sed -i 's/@@NOTE_END@@//g' "$input"


