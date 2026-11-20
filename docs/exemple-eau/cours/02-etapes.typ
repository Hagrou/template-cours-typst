// Chapitre 2 — démontre : #schema (fletcher), #diapo, #selon, #exemple,
// #question avec réponse, #voir, sous-section réservée à l'écrit, tableau.
#import "/lib/theme.typ": *
// Package importé dans le seul fichier qui l'utilise (téléchargé à la
// première compilation, puis mis en cache).
#import "@preview/fletcher:0.5.8": diagram, node, edge

= Les étapes du cycle <eau-02-etapes>

== 🔁 Vue d'ensemble

// Schéma dessiné en Typst : SVG sur le site, vectoriel dans les PDF.
// Couleurs prises dans le thème (primaire, couleurs.*), jamais en dur.
#schema(legende: [Les quatre grandes étapes du cycle de l'eau])[
  #diagram(
    spacing: (7em, 3.5em),
    node-stroke: 0.8pt + primaire,
    node-fill: primaire.lighten(90%),
    node-corner-radius: 4pt,
    node-inset: 0.7em,
    edge-stroke: 0.9pt + primaire,
    node((0, 0), [☀️ Évaporation], name: <evap>),
    node((1, 0), [☁️ Condensation], name: <cond>),
    node((1, 1), [🌧️ Précipitations], name: <prec>),
    node((0, 1), [🏞️ Ruissellement \ et infiltration], name: <ruis>),
    edge(<evap>, <cond>, "-|>", [vapeur]),
    edge(<cond>, <prec>, "-|>", [gouttes], label-side: left),
    edge(<prec>, <ruis>, "-|>", [eau liquide], label-side: left),
    edge(<ruis>, <evap>, "-|>", [retour à l'océan], label-side: left),
  )
]

// Le rappel n'est utile qu'en présentation : #diapo n'apparaît que sur les slides.
#diapo[
  _Rappel_ : le moteur du cycle est l'énergie solaire.
]

== ☀️ Évaporation <eau-02-etapes:evaporation>

#synthese[
  - L'eau liquide devient *vapeur* sous l'effet de la chaleur
  - *≈ 86 %* de l'évaporation provient des océans
  - Les plantes rejettent aussi de la vapeur : la *transpiration*
]

#developpement[
  L'énergie du Soleil chauffe la surface des océans, des lacs et des sols :
  une partie de l'eau passe à l'état gazeux et monte dans l'atmosphère.

  Les végétaux participent aussi : ils puisent l'eau du sol par leurs racines
  et en rejettent une partie par leurs feuilles. On regroupe les deux
  phénomènes sous le terme d'*évapotranspiration*.

  // Ce titre, placé dans #developpement, disparaît des slides : la
  // sous-section complète devient la note de l'orateur de la diapo.
  ==== Facteurs qui favorisent l'évaporation

  - une température élevée ;
  - un air sec (faible humidité) ;
  - du vent, qui renouvelle l'air au-dessus de la surface ;
  - une grande surface d'eau exposée.
]

== ☁️ Condensation

// #selon : une version courte pour les slides, la version longue ailleurs.
#selon(slides: [
  - En altitude, l'air se *refroidit*
  - La vapeur redevient de *fines gouttelettes* → nuages
])[
  En s'élevant, l'air se détend et se refroidit (environ 0,6 °C de moins tous
  les 100 m en air humide). L'air froid ne peut plus contenir autant de
  vapeur : celle-ci se condense en minuscules gouttelettes, ou en cristaux de
  glace, autour de poussières en suspension (les _noyaux de condensation_).
  Ce sont ces gouttelettes qui forment les nuages… et la buée sur une vitre
  froide.
]

#exemple[
  📝 La buée sur un miroir de salle de bain est une condensation : la vapeur
  de la douche rencontre une surface froide.
]

== 🌧️ Précipitations

#synthese[
  - Les gouttelettes grossissent, deviennent trop lourdes et *tombent*
  - Pluie, neige, grêle selon la température
]

// Les tableaux courts restent hors de #developpement : déjà synthétiques,
// ils seraient perdus dans les notes de l'orateur (texte seul).
#table(
  columns: (auto, 1fr),
  [Forme], [Conditions],
  [Pluie], [Température de l'air au-dessus de 0 °C jusqu'au sol],
  [Neige], [Cristaux de glace qui ne fondent pas pendant la chute],
  [Grêle], [Nuages d'orage : la glace remonte et grossit plusieurs fois],
)

// Question avec réponse : sur les slides, une diapo question puis la même
// avec la réponse ; en A4, renvoi vers le corrigé en fin de chapitre ;
// sur le site, réponse repliable.
#question[🧩 Pourquoi pleut-il davantage sur le versant d'une montagne
exposé au vent ?][
  L'air humide poussé par le vent est forcé de *monter* le long du relief.
  En montant, il se refroidit, sa vapeur se condense et précipite : c'est
  l'*effet orographique*. L'autre versant, abrité, reçoit un air déjà
  asséché (effet de foehn).
]

== 🏞️ Ruissellement et infiltration

#synthese[
  - *Ruissellement* : l'eau s'écoule en surface vers les rivières
  - *Infiltration* : l'eau pénètre dans le sol et recharge les nappes
  - Les deux finissent par rejoindre l'océan… et le cycle recommence
]

#developpement[
  La part qui ruisselle et celle qui s'infiltre dépendent de la pente, de la
  nature du sol et de son occupation : un sol sableux absorbe vite, une
  surface bitumée presque pas. C'est pourquoi l'imperméabilisation des villes
  augmente le risque d'inondation.

  On retrouve l'idée de quantité constante vue en
  #voir(<eau-01-introduction:quantite-constante>)[introduction] : aucune
  goutte ne se perd, elle change seulement de chemin.
]

// #ajuster : sur la diapo, le texte est réduit (jusqu'à 60 %) pour tenir
// dans la place restante au lieu de déborder sur une diapo « (suite) ».
#ajuster[
  #plus[
    🎁 *Pour aller plus loin* : en ville, les toitures végétalisées, les noues
    et les revêtements perméables cherchent à rendre au sol sa capacité
    d'infiltration. On parle de _gestion intégrée des eaux pluviales_ : l'idée
    est de traiter la pluie là où elle tombe, plutôt que de l'évacuer au plus
    vite par les réseaux d'égouts.
  ]
]
