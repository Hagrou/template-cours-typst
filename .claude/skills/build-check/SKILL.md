---
name: build-check
description: Compile les 3 cibles du cours Typst Hunting In The Noise (A4, slides, site) et vérifie l'absence de régressions (erreur de compilation, chapitre orphelin, renvoi cassé, image ou fichier manquant, ancre du site sans cible). À utiliser avant un commit, ou après avoir édité/ajouté un fichier dans docs/.
---

# Build check

Vérifie que le cours (`docs/`) se compile proprement
sur ses trois cibles et que rien n'est cassé silencieusement.

## Étapes

1. **Compiler les trois cibles** depuis la racine du dépôt :

   ```bash
   make all
   ```

   Dans le Dev Container, le Makefile appelle `typst` directement ; sur
   l'hôte il passe par l'image Docker (`make image` au préalable si besoin).
   Si `make` est absent, les commandes équivalentes sont celles des cibles
   `a4`, `slides`, `site` du [Makefile](/Makefile).

2. **Lire toute la sortie.** Une erreur Typst donne fichier, ligne et
   colonne : la reporter telle quelle. Seul avertissement attendu :
   `html export is under active development and incomplete` (export HTML
   expérimental de Typst 0.13). Tout autre avertissement est à signaler
   (ex. `block was ignored during HTML export` : un élément graphique
   utilisé hors des fonctions du thème, il manquera sur le site).

3. **Lancer les contrôles que la compilation ne fait pas** :

   ```bash
   bash .claude/skills/build-check/verif-cours.sh
   ```

   Le script vérifie :
   - les `.typ` de `cours/`, `approfondissements/`, `td/`, `ressources/`
     absents de [main.typ](/docs/main.typ) (un
     `#include` commenté = exclusion volontaire, signalée sans erreur) ;
   - les `#voir(<étiquette>)` sans titre portant cette étiquette.
     **Important** : `voir` ne fait pas échouer la compilation quand
     l'étiquette est absente, il affiche le texte sans lien (c'est voulu
     pour les slides, qui n'incluent pas tout). Une faute de frappe dans
     une étiquette passe donc inaperçue sans ce contrôle ;
   - les chemins de `#illustration(…)`, `web:` et `#fichier(…)` ;
   - dans le site généré : ancres `#…` sans `id`, ressources absentes,
     `id` dupliqués ;
   - la liste des marqueurs 🚧 restants (information, pas une erreur).

   Code de retour = nombre de problèmes.

4. **En cas de doute sur le rendu**, faire une planche-contact (voir les
   skills `export-pdf` et `build-slides`).

## Rapport attendu

En quelques lignes :
- compilation réussie ou non, par cible (avec l'erreur exacte sinon) ;
- chapitres orphelins, avec proposition d'`#include` dans `main.typ` à
  l'endroit cohérent (partie et ordre pédagogique) ;
- renvois, images, fichiers cassés, avec fichier et ligne.

Ne pas corriger silencieusement `main.typ` ni les étiquettes : ce sont des
changements de structure du cours, à valider avec l'auteur.
