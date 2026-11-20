#!/usr/bin/env bash
# Contrôles du cours Typst que la compilation ne fait pas échouer.
# Usage (racine du dépôt) : bash .claude/skills/build-check/verif-cours.sh
# Code de retour : nombre de problèmes trouvés (0 = tout va bien).
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DOC="$ROOT/docs"
SITE="$ROOT/target/site"
cd "$DOC" || exit 1
pb=0
signale() { echo "  ✗ $*"; pb=$((pb + 1)); }

# Fichiers inclus (lignes #include non commentées de main.typ)
inclus=$(grep -E '^\s*#include "' main.typ | sed -E 's/.*#include "([^"]+)".*/\1/' | sort)
commentes=$(grep -E '^\s*//\s*#include "' main.typ | sed -E 's/.*#include "([^"]+)".*/\1/' | sort)

echo "1. Chapitres non inclus dans main.typ"
for f in $(find cours approfondissements td ressources -name '*.typ' | sort); do
  if ! grep -qxF "$f" <<<"$inclus"; then
    if grep -qxF "$f" <<<"$commentes"; then
      echo "  · $f (exclu volontairement : #include commenté)"
    else
      signale "$f n'est inclus nulle part (orphelin)"
    fi
  fi
done
for f in $inclus; do [ -f "$f" ] || signale "main.typ inclut $f, introuvable"; done

echo "2. Renvois #voir(<…>) vers une étiquette inexistante"
etiquettes=$(grep -rhoE '^=+ .* <[^>]+>\s*(//.*)?$' --include='*.typ' . | sed -E 's/\s*\/\/.*$//; s/.*<([^>]+)>\s*$/\1/' | sort -u)
grep -rnoE '#voir\(<[^>]+>\)' --include='*.typ' . | while IFS=: read -r fic ligne m; do
  e=$(sed -E 's/#voir\(<([^>]+)>\)/\1/' <<<"$m")
  grep -qxF "$e" <<<"$etiquettes" || echo "$fic:$ligne <$e>"
done > /tmp/verif-voir.$$
while read -r l; do signale "étiquette inconnue : $l"; done < /tmp/verif-voir.$$
rm -f /tmp/verif-voir.$$

echo "3. Images et fichiers référencés"
grep -rnoE '#illustration\("[^"]+"|web: "[^"]+"' --include='*.typ' . | while IFS=: read -r fic ligne m; do
  p=$(sed -E 's/.*"\/?([^"]+)"/\1/' <<<"$m")
  [ -f "$p" ] || echo "$fic:$ligne $p"
done > /tmp/verif-img.$$
grep -rnoE '#fichier\("[^"]+"' --include='*.typ' . | while IFS=: read -r fic ligne m; do
  p=$(sed -E 's/.*"([^"]+)"/\1/' <<<"$m")
  [ -e "$p" ] || echo "$fic:$ligne $p"
done >> /tmp/verif-img.$$
while read -r l; do signale "fichier manquant : $l"; done < /tmp/verif-img.$$
rm -f /tmp/verif-img.$$

echo "4. Site généré (liens internes et ressources)"
if [ -f "$SITE/index.html" ]; then
  ids=$(grep -o 'id="[^"]*"' "$SITE/index.html" | sed 's/id="//;s/"//' | sort -u)
  for a in $(grep -o 'href="#[^"]*"' "$SITE/index.html" | sed 's/href="#//;s/"//' | grep . | sort -u); do
    grep -qxF "$a" <<<"$ids" || signale "ancre #$a sans cible dans index.html"
  done
  for r in $(grep -oE '(src|href)="[^"#][^"]*"' "$SITE/index.html" | sed -E 's/.*="//;s/"$//' | grep -vE '^(https?|mailto):' | sort -u); do
    [ -e "$SITE/$r" ] || signale "ressource absente du site : $r"
  done
  dup=$(grep -o 'id="[^"]*"' "$SITE/index.html" | sort | uniq -d)
  [ -z "$dup" ] || signale "id dupliqués : $dup"
else
  echo "  · site non généré (lancer make site), contrôle sauté"
fi

echo "5. Marqueurs 🚧 restants"
grep -rn '🚧' --include='*.typ' cours approfondissements td ressources | sed 's/^/  · /'

echo
[ "$pb" -eq 0 ] && echo "OK : aucun problème." || echo "$pb problème(s)."
exit "$pb"
