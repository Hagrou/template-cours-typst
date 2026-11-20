---
name: export-pdf
description: Génère le document A4 (PDF) du cours Typst Hunting In The Noise et contrôle son rendu. À utiliser quand l'utilisateur veut diffuser ou imprimer le cours en PDF.
---

# Export PDF (document A4)

Le document A4 est une des trois cibles du source unique
[main.typ](/docs/main.typ), compilée avec
`--input cible=a4`. Mise en page (page de titre, sommaire, intercalaires de
partie, en-têtes, encadrés) entièrement dans
[lib/theme.typ](/docs/lib/theme.typ), fonction
`_gabarit-a4`.

## Étapes

1. **Compiler** depuis la racine du dépôt :

   ```bash
   make a4
   ```

   Résultat : `target/hunting-in-the-noise.pdf`
   (tout le cours : Cours, Approfondissements, TD, Ressources ; environ
   150 pages). Pour itérer : `make watch CIBLE=a4`.

2. **Contrôler le rendu à l'œil**, pas seulement le code de retour :

   ```bash
   bash .claude/skills/build-check/planche.sh a4 1-16 8
   ```

   puis lire l'image produite (chemin affiché). Points à regarder :
   - **emojis** (🧩📐🎁📝🚧…) : des carrés vides = police
     `Noto Color Emoji` absente (paquet `fonts-noto-color-emoji`, dans le
     [Dockerfile](/Dockerfile)) ;
   - **réponses** : chaque `#question[…][…]` doit montrer l'encadré vert
     « Réponse » sous la question (en PDF les réponses sont toujours
     dépliées) ;
   - **schémas draw.io** : en PDF on utilise l'export `.drawio.png`, car
     Typst ne rend pas le texte en `foreignObject` des SVG draw.io (boîtes
     noires sans texte). Si un nouveau SVG draw.io est ajouté, passer le
     PNG en chemin principal et le SVG en `web:` ;
   - **tableaux** : colonnes trop étroites → ajuster `columns:` dans le
     `#table` concerné (ex. `(auto, 1fr, 2fr)`).

   Pour zoomer sur une page précise :
   `bash .claude/skills/build-check/planche.sh a4 42 1 90`.

3. **Vérifier la cohérence** avec `build-check` si des fichiers ont été
   ajoutés ou renommés (un renvoi cassé ne fait pas échouer la compilation).

## Points d'attention

- Le PDF reflète l'état courant des sources : recompiler après chaque
  modification avant de le diffuser.
- Nom de sortie : celui du Makefile par défaut ; suivre une préférence
  explicite de l'utilisateur si elle est donnée (passer un autre chemin à
  `typst compile`).
- Les pages hors partie « Cours » ne figurent que dans l'A4 et le site, pas
  dans les slides : c'est voulu.
