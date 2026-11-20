#!/usr/bin/env bash
# Captures des thèmes visuels (docs/manuel/themes.md) à partir de
# docs/manuel/themes/demo.typ, compilé avec chaque thème sur les 3 cibles.
# Usage (racine du dépôt) : bash docs/manuel/captures-themes.sh
set -euo pipefail
cd "$(dirname "$0")/../.."
SRC=docs/manuel/themes/demo.typ
OUT=docs/manuel/themes
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
CHROME=$(command -v chromium-headless-shell || command -v chromium || true)
THEMES=$(sed -nE 's/^  ([a-z]+): \(.*/\1/p' docs/lib/theme.typ | sed -n '/^classique$/,$p')

for t in $THEMES; do
  rm -f "$OUT/$t"-*.png
  typst compile --root docs --input cible=slides --input theme=$t --ppi 60 "$SRC" "$TMP/$t-slides-{p}.png"
  typst compile --root docs --input cible=a4 --input theme=$t --ppi 70 "$SRC" "$TMP/$t-a4-{p}.png"
  # Diapos : 1 titre, 2 chapitre, 3 synthèse, 4 tableau, 6 question + réponse
  for p in 1 2 3 4 6; do cp "$TMP/$t-slides-$p.png" "$OUT/$t-slides-$p.png"; done
  # A4 : 1 page de titre, 3 premier chapitre
  for p in 1 3; do cp "$TMP/$t-a4-$p.png" "$OUT/$t-a4-$p.png"; done
  if [ -n "$CHROME" ]; then
    mkdir -p "$TMP/site"
    typst compile --root docs --features html --format html --input cible=site --input theme=$t "$SRC" "$TMP/site/$t.html" 2>/dev/null
    cp docs/lib/site.css "$TMP/site/style.css"
    "$CHROME" --headless --no-sandbox --disable-gpu --hide-scrollbars \
      --window-size=1100,760 --screenshot="$OUT/$t-site.png" "file://$TMP/site/$t.html" >/dev/null 2>&1
  fi
done
ls "$OUT"
