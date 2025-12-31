#!/usr/bin/env bash
# OURCODE decoder (v4) - NOTES as blockquotes, TABLE blocks to pipe tables
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

tmp="$input"
if [[ -n "${output:-}" ]]; then
  cp -- "$input" "$output"
  tmp="$output"
fi

# Pre-pass: NOTE -> blockquote lines, TABLE -> pipe table
awk '
function trim(s){ sub(/^[ \t\r\n]+/,"",s); sub(/[ \t\r\n]+$/,"",s); return s }

# Split a row using tabs if present, otherwise spaces.
# If expected > 0 and we get too many tokens, merge extras into the last cell.
function split_row(line, arr, expected,   n,i,tmp) {
  n = split(line, arr, "\t")
  if (n == 1) {
    n = split(trim(line), arr, /[ ]+/)
  }
  if (expected > 0 && n > expected) {
    tmp = arr[expected]
    for (i = expected + 1; i <= n; i++) tmp = tmp " " arr[i]
    for (i = expected + 1; i <= n; i++) delete arr[i]
    arr[expected] = tmp
    n = expected
  }
  return n
}

function emit_row(line, expected,   n,i,out,cell) {
  n = split_row(line, cell, expected)
  out="|"
  for(i=1;i<=n;i++) out = out " " trim(cell[i]) " |"
  print out
  return n
}
function emit_sep(n,   i,out) {
  out="|"
  for(i=1;i<=n;i++) out = out " --- |"
  print out
}

BEGIN { in_note=0; in_table=0; table_rows=0; expected_cols=0 }

{
  if ($0 ~ /^@@NOTE@@/) { in_note=1; next }
  if ($0 ~ /^@@NOTE_END@@/) { in_note=0; next }

  if ($0 ~ /^@@TABLE@@/) { in_table=1; table_rows=0; expected_cols=0; next }
  if ($0 ~ /^@@TABLE_END@@/) {
    if (table_rows >= 1) {
      # header decides expected column count
      expected_cols = emit_row(table[1], 0)
      emit_sep(expected_cols)
      for (r=2; r<=table_rows; r++) emit_row(table[r], expected_cols)
    }
    delete table
    in_table=0
    next
  }

  if (in_note) { print "> " $0; next }

  if (in_table) {
    if ($0 !~ /^[ \t]*$/) table[++table_rows] = $0
    next
  }

  print $0
}
' "$tmp" > "${tmp}.pp"
mv -- "${tmp}.pp" "$tmp"

# Your original sed decoding (unchanged)
sed -i 's/@@H1@@/# /g'  "$tmp"
sed -i 's/@@H1_END@@//g' "$tmp"
sed -i 's/@@H2@@/## /g' "$tmp"
sed -i 's/@@H2_END@@//g' "$tmp"
sed -i 's/@@H3@@/### /g' "$tmp"
sed -i 's/@@H3_END@@//g' "$tmp"

sed -i 's/@@P@@//g' "$tmp"
sed -i 's/@@P_END@@//g' "$tmp"

sed -i 's/@@BOLD@@/**/g' "$tmp"
sed -i 's/@@BOLD_END@@/**/g' "$tmp"

sed -i 's/@@CODE@@/`/g' "$tmp"
sed -i 's/@@CODE_END@@/`/g' "$tmp"

sed -i 's/@@LIST_ITEM@@/- /g' "$tmp"
sed -i 's/@@LIST_ITEM_END@@//g' "$tmp"

sed -i 's/@@CODEBLOCK_JAVA@@/```java/g' "$tmp"
sed -i 's/@@CODEBLOCK_TEXT@@/```text/g' "$tmp"
sed -i 's/@@CODEBLOCK_BASH@@/```bash/g' "$tmp"
sed -i 's/@@CODEBLOCK_END@@/```/g' "$tmp"

echo "Decoded OURCODE → Markdown: $tmp"
