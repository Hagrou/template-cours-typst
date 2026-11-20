---
name: nouveau-module
description: Crée un nouveau chapitre du cours Typst Hunting In The Noise (docs/cours/NN-titre.typ) à partir du gabarit standard, et l'inclut dans main.typ (donc dans l'A4, le site et les slides). À utiliser quand l'utilisateur demande d'ajouter un nouveau module, chapitre ou section principale au cours (pas une fiche d'approfondissement — voir le skill addon-attaque pour ça).
---

# Nouveau module de cours

Crée un chapitre au même niveau que
[02-bonne-detection.typ](/docs/cours/02-bonne-detection.typ)
ou
[03-ingenierie-detection.typ](/docs/cours/03-ingenierie-detection.typ),
en respectant les conventions en place, et l'intègre aux trois cibles.

## Étapes

1. **Déterminer le numéro et le nom de fichier.** Les chapitres suivent le
   motif `NN-titre-kebab-case.typ` dans
   [cours/](/docs/cours/). Choisir le prochain numéro
   disponible, en cohérence avec la place du module dans le plan des 3
   jours (tableau de
   [cours/programme.typ](/docs/cours/programme.typ)).

2. **Demander (ou déduire du contexte) le sujet et l'objectif
   pédagogique** si ce n'est pas déjà clair : à quelle journée / quel
   thème il se rattache, ce que le stagiaire doit savoir faire à la fin.

3. **Générer le contenu à partir du gabarit**
   [templates/module.typ](templates/module.typ), en remplaçant les `{{…}}`.
   Respecter le style du cours :
   - premier titre `= Titre <NN-titre>` : l'étiquette = nom du fichier,
     utilisée par les renvois `#voir(<NN-titre>)[…]` ;
   - encadrés à valeur fixe (fonction + emoji concordants) :
     `#question[🧩 …][Réponse]` (question au groupe, réponse en 2e
     argument), `#concept[📐 …]` (repère théorique), `#plus[🎁 …]` (pour
     aller plus loin), `#exemple[📝 …]` (exemple concret, rattaché à un
     fil rouge unique sur la page), `#afaire[🚧 …]` (point à compléter,
     explicité plutôt que caché) ;
   - titres `==`/`===` préfixés d'un emoji thématique quand ça structure
     la lecture (➡️, ⚙️, 🔬, 💰, 😈…), pris dans la palette du
     [README du cours](/docs/README.md), sans en
     abuser ;
   - `#table(...)` pour tout ce qui est comparatif, cycle en étapes ou
     liste structurée ;
   - deux colonnes (texte + image) : `#colonnes[…][…]` ; image :
     `#illustration("/images/x.png", alt: "…", largeur: 80%)` ; schéma :
     skill `schema-diagramme` ;
   - références numérotées `[1]` + section `== Références` en bas de page ;
   - phrases courtes, ton direct.

   **Penser aux slides** : un chapitre de `cours/` est projeté. Chaque
   `==`/`===` ouvre une diapo ; découper en unités qui tiennent sur une
   diapo (une section trop longue s'étale sur plusieurs diapos « (suite) »).
   Écrire chaque section explicative en deux temps : `#synthese[…]` (3 à 5
   puces courtes : la diapo, et un encadré « 🎯 À retenir » en A4/site)
   puis `#developpement[…]` (la prose complète : A4/site, et notes de
   l'orateur en slides). Les `#question` restent hors de `#developpement`.
   Cf. [02-bonne-detection.typ](/docs/cours/02-bonne-detection.typ) et la
   section « Niveau de détail selon la cible » du
   [README du cours](/docs/README.md).

4. **Écrire le fichier** `docs/cours/NN-titre.typ`.

5. **L'inclure dans [main.typ](/docs/main.typ)**,
   partie « Cours » (avant le bloc `#if not est-slides`), à l'endroit
   cohérent avec l'ordre pédagogique (pas forcément l'ordre numérique). Un
   fichier non inclus n'apparaît dans aucune cible ; `build-check` le
   signale comme orphelin.

6. **Vérifier** avec le skill `build-check`, puis regarder les diapos du
   nouveau chapitre (skill `build-slides`, planche-contact).

## Ne pas faire

- Ne pas inventer de contenu technique pointu (TTP, requêtes de détection,
  chiffres) sans le signaler : utiliser `#afaire[🚧 …]` pour un point à
  vérifier/compléter par l'auteur.
- Ne pas renuméroter les chapitres existants sans demander : ça casse les
  étiquettes (`<02-bonne-detection>`…) donc les renvois `#voir`, et les
  habitudes de l'auteur.
