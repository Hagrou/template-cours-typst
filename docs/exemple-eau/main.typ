// =============================================================================
// EXEMPLE DE COURS : « Le cycle de l'eau »
//
// Cours de démonstration du template : un seul source, trois rendus.
//
//   make all                          -> A4 + slides (+ notes .pdfpc) + site
//   make all THEME=soc                -> idem avec un autre thème visuel
//
// Produits dans target/exemple-eau/ :
//   exemple-eau.pdf             document A4 (titre, sommaire, corrigés)
//   exemple-eau-slides.pdf      diapositives 16:9
//   exemple-eau-slides.pdfpc    notes de l'orateur (pdfpc, pympress)
//   site/index.html             site web (réponses repliables)
//
// Pour démarrer un nouveau cours : copier ce dossier, changer les
// métadonnées ci-dessous et remplacer les chapitres.
// =============================================================================

#import "/lib/theme.typ": *

// Métadonnées : page de titre, en-têtes, pieds de page, bandeau du site.
#show: gabarit.with(
  titre: "Le cycle de l'eau",
  sous-titre: "Exemple de cours réalisé avec le template",
  auteur: "Équipe pédagogique",
)

// --- Partie « Cours » : A4, site ET slides --------------------------------
#partie[Cours]
#include "cours/01-introduction.typ"
#include "cours/02-etapes.typ"
#include "cours/03-reservoirs.typ"

// --- Partie « Travaux dirigés » : A4 et site seulement --------------------
// Le matériel de pratique n'est pas taillé pour la diapositive : on l'exclut
// des slides avec le test `est-slides` fourni par le thème.
#if not est-slides [
  #partie[Travaux dirigés]
  #include "td/td-bilan-hydrique.typ"
]
