---
name: build-slides
description: Génère les diapositives (PDF 16:9) du cours Typst Hunting In The Noise, à partir de la partie « Cours » (programme et chapitres 02 à 06), et contrôle leur rendu. À utiliser quand l'utilisateur veut le cours sous forme de diapositives/slides/présentation.
---

# Build slides

Les slides sont une des trois cibles du source unique
[main.typ](/docs/main.typ) (`--input cible=slides`).
Aucun préprocesseur : c'est le thème
([lib/theme.typ](/docs/lib/theme.typ), fonction
`_gabarit-slides`) qui décide du découpage et du rendu.

## Comment le découpage fonctionne

- **Périmètre** : seule la partie « Cours » est incluse (le bloc
  `#if not est-slides [...]` de `main.typ` exclut approfondissements, TD et
  ressources, pensés comme matériel de référence/pratique). L'étendre est
  possible mais demande un retravail éditorial : en discuter d'abord.
- **Une diapo par titre** `=` (chapitre : diapo de titre), `==` et `===`.
  Un titre `====` ne coupe pas. Le titre des niveaux 2-3 est dessiné dans
  l'en-tête de page (zone réservée), pas dans le corps.
- **Débordement** : un contenu trop long continue sur la diapo suivante,
  qui reprend le titre suivi de « (suite) ». Pas de réduction de police
  automatique. Beaucoup de « (suite) » sur une même section = signal pour
  découper le contenu (ajouter un `===`), pas pour réduire la police.
- **Questions** : `#question[Énoncé][Réponse]` est insécable, question et
  réponse restent toujours sur la même diapo, réponse visible.
- **Tableaux** : un tableau qui tient sur une diapo n'est pas coupé ; un
  tableau plus haut continue sur la suivante.
- **Colonnes** : `#colonnes[…][…]` produit les mêmes colonnes sur le site,
  l'A4 et les slides.
- **Renvois** vers des pages non incluses (`#voir(<attack_lsass>)[…]`) :
  affichés en texte simple, sans erreur.
- Pied de page : nom du cours, chapitre courant, `N / Total`.

## Étapes

1. **Compiler** depuis la racine du dépôt :

   ```bash
   make slides
   ```

   Résultat : `target/hunting-in-the-noise-slides.pdf`
   (un seul PDF pour tout le cours) et, à côté,
   `target/hunting-in-the-noise-slides.pdfpc` : les notes de l'orateur
   (texte des `#developpement[…]`), lues par pdfpc ou pympress. Pour
   itérer : `make watch CIBLE=slides` (PDF seul, sans le `.pdfpc`).

   Le niveau de détail des slides se règle dans les chapitres avec
   `#synthese`, `#developpement`, `#diapo` et `#selon` (cf. section
   « Niveau de détail selon la cible » du [README](/docs/README.md)).
   Vérifier les notes : `typst query --root docs --input cible=slides
   docs/main.typ "<note-orateur>" --field value`.

2. **Vérifier visuellement**, en particulier les sections denses
   (chapitre 06 : tableaux, colonnes, images ; chapitre 05 : règles
   Sigma) :

   ```bash
   bash .claude/skills/build-check/planche.sh slides 1-24 6
   ```

   Regarder : titre qui chevauche le contenu, image trop grande, tableau
   tronqué, diapo presque vide suivie d'une « (suite) » (contenu à
   rééquilibrer). Une section trop verbeuse se condense avec
   `#synthese[puces]` + `#developpement[texte]` (le texte passe en note
   de l'orateur) plutôt qu'en réduisant la taille du texte.

3. **Pour une diapo isolée**, à taille lisible :
   `bash .claude/skills/build-check/planche.sh slides 37 1 80`.

## Réglages courants (dans `_gabarit-slides`)

- Taille du texte : `set text(size: 20pt)`.
- Hauteur maximale des images : `height: 11cm` dans `illustration()`.
- Seuil de non-coupure des tableaux : `if h < 11cm` dans la règle
  `show table`.
