#!/usr/bin/env bash
# Régénère les copies d'écran de docs/manuel.md à partir des exemples
# (docs/manuel/exemples/*.typ), sur les 3 cibles.
# Usage (racine du dépôt) : bash docs/manuel/captures.sh
# Prérequis : typst ; chromium-headless-shell (ou chromium) pour le site.
set -euo pipefail
cd "$(dirname "$0")/../.."
EX=docs/manuel/exemples
OUT=docs/manuel/captures
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
CHROME=$(command -v chromium-headless-shell || command -v chromium || true)

for f in "$EX"/*.typ; do
  n=$(basename "$f" .typ)
  rm -f "$OUT/$n"-*.png
  # A4 : p1 = page de titre, p2 = sommaire -> on garde à partir de p3
  typst compile --root docs --input cible=a4 --ppi 80 "$f" "$TMP/$n-a4-{p}.png"
  # Slides : p1 = diapo de titre, p2 = diapo de chapitre -> à partir de p3
  typst compile --root docs --input cible=slides --ppi 60 "$f" "$TMP/$n-slides-{p}.png"
  for p in "$TMP/$n"-a4-*.png "$TMP/$n"-slides-*.png; do
    num=$(sed -E 's/.*-([0-9]+)\.png/\1/' <<<"$p"); num=$((10#$num))
    [ "$num" -ge 3 ] && cp "$p" "$OUT/$(basename "$p" | sed -E "s/-0*$num\.png/-$((num-2)).png/")"
  done
  # Notes de l'orateur (texte)
  typst query --root docs --input cible=slides "$f" "<note-orateur>" --field value > "$OUT/$n-notes.json"
  [ "$(cat "$OUT/$n-notes.json")" = "[]" ] && rm "$OUT/$n-notes.json"
  # Site : HTML + feuille de style, capture par chromium
  if [ -n "$CHROME" ]; then
    mkdir -p "$TMP/site/images"
    typst compile --root docs --features html --format html --input cible=site "$f" "$TMP/site/$n.html" 2>/dev/null
    cp docs/lib/site.css "$TMP/site/style.css"; cp -r docs/images/* "$TMP/site/images/"
    # variante « réponses dépliées »
    sed 's/<details class="reponse">/<details class="reponse" open>/g' "$TMP/site/$n.html" > "$TMP/site/$n-ouvert.html"
    H=$(sed -nE "s#^// hauteur-site: ([0-9]+)#\1#p" "$f"); H=${H:-700}
    for v in "$n" "$n-ouvert"; do
      "$CHROME" --headless --no-sandbox --disable-gpu --hide-scrollbars \
        --window-size=1100,$H --screenshot="$OUT/$v-site.png" "file://$TMP/site/$v.html" >/dev/null 2>&1
    done
    cmp -s "$OUT/$n-site.png" "$OUT/$n-ouvert-site.png" && rm "$OUT/$n-ouvert-site.png"
  fi
done
ls "$OUT"
