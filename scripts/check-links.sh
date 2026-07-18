#!/usr/bin/env bash
# Link/asset existence check for the static site.
# Verifies that every local href/src referenced by the HTML pages exists on
# disk, and that every in-page #anchor points at a real element id.
# No dependencies beyond bash + grep/sed. Run from anywhere.
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0

for page in index.html privacy.html; do
  refs=$(grep -oE '(href|src)="[^"]+"' "$page" | sed -E 's/^(href|src)="//; s/"$//' | sort -u)
  while IFS= read -r ref; do
    [ -n "$ref" ] || continue
    case "$ref" in
      http://*|https://*|mailto:*|tel:*|data:*) continue ;;
      '#')
        continue ;;
      \#*)
        anchor="${ref#\#}"
        if ! grep -q "id=\"$anchor\"" "$page"; then
          echo "BROKEN ANCHOR in $page: #$anchor"
          fail=1
        fi
        continue ;;
    esac
    path="${ref%%#*}"
    path="${path%%\?*}"
    if [ ! -f "$path" ]; then
      echo "MISSING FILE referenced in $page: $path"
      fail=1
    fi
  done <<< "$refs"
done

if [ "$fail" -ne 0 ]; then
  echo "Link check FAILED"
  exit 1
fi
echo "Link check passed: all local references resolve."
