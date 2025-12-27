#!/usr/bin/env bash
# OURCODE decoder (v4) - robust NOTES + TABLE blocks
# Usage:
#   chmod +x decode_md.sh
#   ./decode_md.sh input_safe.txt output.md
# Notes:
# - If output.md is omitted, edits input file in-place.
# - Uses awk + sed (still deterministic). GNU sed syntax (-i). macOS: sed -i '' ...

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
if [[ -n "$output" ]]; then
  cp -- "$input" "$output"
  tmp="$output"
fi

# Step 1: Handle NOTE and TABLE blocks while tags are still present.
# - NOTE: turn into blockquote lines (no injected "Note:")
# - TABLE: convert tab-separated rows into Markdown pipe table
awk '
function trim(s){ sub(/^[ \t\r\n]+/,"",s); sub(/[ \t\r\n]+$/,"",s); return s }
function emit_row(arr, n,    i, out) {
  out="|"
  for(i=1;i<=n;i++){
    out = out " " trim(arr[i]) " |"
  }
  print out
}
function emit_sep(n,    i, out) {
  out="|"
  for(i=1;i<=n;i++){
    out = out " --- |"
  }
  print out
}

BEGIN { in_note=0; in_table=0; table_rows=0 }

{
  if ($0 ~ /^@@NOTE@@/) { in_note=1; next }
  if ($0 ~ /^@@NOTE_END@@/) { in_note=0; next }

  if ($0 ~ /^@@TABLE@@/) { in_table=1; table_rows=0; next }
  if ($0 ~ /^@@TABLE_END@@/) {
    # Emit table if at least header exists
    if (table_rows >= 1) {
      # header
      n = split(table[1], h, "\t")
      emit_row(h, n)
      emit_sep(n)
      # body
      for (r=2; r<=table_rows; r++) {
        split(table[r], c, "\t")
        emit_row(c, n)
      }
    }
    # cleanup
    delete table
    in_table=0
    next
  }

  if (in_note) {
    # Prefix every note line as a proper blockquote
    print "> " $0
    next
  }

  if (in_table) {
    # Collect raw tab-separated lines (leave empty lines out)
    if ($0 !~ /^[ \t]*$/) {
      table[++table_rows] = $0
    }
    next
  }

  print $0
}
' "$tmp" > "${tmp}.awk"
mv -- "${tmp}.awk" "$tmp"

# Step 2: Regular tag decoding with sed (backward-compatible with your v3 script)
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
