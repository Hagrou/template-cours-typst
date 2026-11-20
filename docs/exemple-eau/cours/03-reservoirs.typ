// Chapitre 3 — démontre : tableau chiffré, formule mathématique, #details,
// #afaire, #voir vers un TD (texte seul dans les slides, qui ne l'incluent
// pas), plusieurs questions avec réponse.
#import "/lib/theme.typ": *

= Les réservoirs et les flux <eau-03-reservoirs>

== 🌍 Où se trouve l'eau ?

#table(
  columns: (1fr, auto),
  align: (left, right),
  [Réservoir], [Part de l'eau totale],
  [Océans et mers], [96,5 %],
  [Glaciers et calottes polaires], [1,7 %],
  [Eaux souterraines], [1,7 %],
  [Lacs, rivières, sols, atmosphère, êtres vivants], [< 0,1 %],
)

#synthese[
  - *Eau douce* : à peine *2,5 %* du total
  - Dont plus des deux tiers *gelés* dans les glaces
]

#developpement[
  Ordres de grandeur d'après l'USGS (_United States Geological Survey_).
  L'eau douce liquide et accessible, celle des lacs et rivières, représente
  une infime fraction du total : c'est pourquoi sa gestion est un enjeu
  majeur.
]

#question[🧩 Si toute l'eau de la Terre tenait dans une bouteille de 1 L,
quel volume d'eau douce non gelée contiendrait-elle à peu près ?][
  Environ *8 mL*, soit une cuillère à café : 2,5 % d'eau douce, dont près
  de 70 % gelés, laissent environ 0,8 % du total (en grande majorité des
  eaux souterraines).
]

== ⏱️ Temps de résidence

#synthese[
  - Durée moyenne qu'une molécule passe dans un réservoir
  - De *quelques jours* (atmosphère) à *des millénaires* (océans, glaces)
]

#table(
  columns: (1fr, auto),
  align: (left, right),
  [Réservoir], [Temps de résidence moyen],
  [Atmosphère], [≈ 9 jours],
  [Rivières], [2 à 6 mois],
  [Lacs], [50 à 100 ans],
  [Eaux souterraines profondes], [jusqu'à 10 000 ans],
  [Océans], [≈ 3 000 ans],
)

// Bloc repliable sur le site, déplié en PDF. Dans #ajuster : sur la diapo,
// réduit pour tenir sous le tableau au lieu de créer une diapo « (suite) ».
#ajuster[#details("📐 Comment calcule-t-on un temps de résidence ?")[
  On divise le volume du réservoir par le flux qui le traverse :
  $ T_"résidence" = V_"réservoir" / Q_"flux sortant" $
  Exemple : l'atmosphère contient environ 13 000 km³ d'eau et en perd
  environ 500 000 km³ par an en précipitations, soit
  13 000 / 500 000 ≈ 0,026 an, c'est-à-dire *≈ 9 jours*.
]
]

== ⚖️ Le bilan hydrique

#synthese[
  - Ce qui tombe = ce qui s'évapore + ce qui s'écoule + ce qui s'infiltre
  - Utilisé à l'échelle d'un *bassin versant*
]

// Une formule centrée : rendue en MathML sur le site, en vectoriel en PDF.
$ P = E T + R + I $

#developpement[
  - $P$ : précipitations
  - $E T$ : évapotranspiration
  - $R$ : ruissellement (mesuré à l'exutoire par le débit de la rivière)
  - $I$ : infiltration et variation du stock d'eau du sol

  Toutes les grandeurs sont exprimées en millimètres d'eau sur la surface du
  bassin (1 mm sur 1 km² = 1 000 m³). Vous appliquerez ce bilan dans le
  #voir(<eau-td-bilan>)[TD « Bilan hydrique d'un bassin versant »].
]

// Point à compléter par l'auteur : visible partout (marqueur de travail),
// à retirer avant diffusion.
#afaire[🚧 Ajouter une carte des grands bassins versants français.]

#question[🧩 Une année très sèche, la rivière continue de couler alors qu'il
n'a presque pas plu. D'où vient son eau ?][
  Des *nappes souterraines* : alimentées pendant les périodes humides, elles
  se vidangent lentement dans les rivières (le _débit de base_). Leur temps
  de résidence long amortit les sécheresses de courte durée.
]
