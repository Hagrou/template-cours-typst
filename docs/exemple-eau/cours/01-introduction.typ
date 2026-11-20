// Chapitre 1 — démontre : étiquette de chapitre, #synthese / #developpement,
// #colonnes + #illustration, #concept, #note, #question sans réponse.
#import "/lib/theme.typ": *

// L'étiquette <eau-01-introduction> permet les renvois #voir(...) depuis
// les autres chapitres.
= Introduction <eau-01-introduction>

== 🎯 Objectifs du cours

// Sans bloc particulier, le contenu est identique sur les trois cibles.
À l'issue de ce cours, vous saurez :

- décrire les grandes étapes du cycle de l'eau ;
- situer les principaux réservoirs d'eau sur Terre et leur importance ;
- calculer un bilan hydrique simple à l'échelle d'un bassin versant.

== 💧 Une quantité d'eau constante <eau-01-introduction:quantite-constante>

// Mise en page « texte | image ». #selon remplace le texte pour les slides
// sans toucher à l'image.
#colonnes[
  #synthese[
    - L'eau *ne se crée pas et ne disparaît pas* : elle circule
    - Moteur : l'*énergie solaire* et la *gravité*
    - Environ *1,4 milliard de km³* sur Terre
  ]
][
  #illustration("/exemple-eau/images/cycle-eau.svg", alt: "Schéma simplifié du cycle de l'eau", largeur: 100%)
]

#developpement[
  La quantité totale d'eau sur Terre est pratiquement constante depuis des
  centaines de millions d'années. Elle change seulement d'*état* (liquide,
  solide, gazeux) et de *réservoir* (océan, atmosphère, glaciers, sols…).

  Deux moteurs font tourner le cycle :
  - le *Soleil* fournit l'énergie qui évapore l'eau ;
  - la *gravité* la fait retomber (précipitations) puis s'écouler vers
    les points bas, jusqu'à l'océan.

  #note[Une molécule d'eau que vous buvez aujourd'hui a probablement déjà
  traversé l'océan, des nuages et des glaciers à plusieurs reprises.]
]

== 📐 Définition

// Un encadré coloré simple, rendu identique sur les trois cibles.
#concept[
  *Cycle de l'eau* (ou *cycle hydrologique*) : ensemble des échanges d'eau,
  sous ses trois états, entre l'océan, l'atmosphère, les continents et les
  êtres vivants.
]

// Question ouverte sans réponse : simple encadré 🧩, sur une seule diapo.
#question[🧩 Citez trois endroits où l'on trouve de l'eau sur Terre, en
dehors des océans.]
