#!/usr/bin/env bash
# Planche-contact PNG de pages d'une cible PDF, pour vérifier le rendu à l'œil
# (police manquante, débordement, chevauchement…) sans visionneuse PDF.
#
#   bash .claude/skills/build-check/planche.sh <a4|slides> <pages> [colonnes] [ppi] [sortie.png]
#   ex. : bash .claude/skills/build-check/planche.sh slides 1-24 6
#
# Les pages sont rendues par Typst lui-même (aucun outil externe requis).
set -euo pipefail

CIBLE="${1:?cible a4|slides}"
PAGES="${2:?pages, ex. 1-12}"
COLS="${3:-4}"
PPI="${4:-40}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
SORTIE="${5:-$ROOT/target/planche-$CIBLE-$PAGES.png}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$(dirname "$SORTIE")"
typst compile --root "$ROOT/docs" --input cible="$CIBLE" \
  --format png --ppi "$PPI" --pages "$PAGES" \
  "$ROOT/docs/main.typ" "$TMP/p-{0p}.png"

{
  echo '#set page(width: auto, height: auto, margin: 4pt, fill: gray)'
  echo "#grid(columns: $COLS, gutter: 4pt,"
  for f in "$TMP"/p-*.png; do echo "  image(\"$(basename "$f")\"),"; done
  echo ')'
} > "$TMP/planche.typ"
typst compile --format png --ppi 72 "$TMP/planche.typ" "$SORTIE"
echo "$SORTIE"
