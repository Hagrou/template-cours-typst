// TD — démontre : données lues dans un fichier CSV (tableau et total
// calculés par Typst), #fichier (fichier fourni, copié sur le site),
// questions numérotées avec corrigé, #voir vers un chapitre du cours.
// Ce fichier n'est inclus que dans l'A4 et le site (cf. main.typ).
#import "/lib/theme.typ": *

= TD : bilan hydrique d'un bassin versant <eau-td-bilan>

== Contexte

Le bassin versant de la Rivière-Claire couvre *120 km²*. Une station
météorologique et une station de mesure du débit à l'exutoire fournissent les
données d'une année complète.

Rappel du bilan (cf. #voir(<eau-03-reservoirs>)[chapitre « Réservoirs et flux »]) :
$ P = E T + R + I $

== Données

Les précipitations mensuelles sont fournies dans le fichier
#fichier("exemple-eau/td/pluie-mensuelle.csv")[pluie-mensuelle.csv].

// Le tableau est construit à partir du CSV : modifier le fichier suffit à
// mettre à jour l'A4 et le site.
#let pluie = csv("/exemple-eau/td/pluie-mensuelle.csv", row-type: dictionary)
#let total = pluie.map(l => int(l.pluie_mm)).sum()

#table(
  columns: (1fr, auto),
  align: (left, right),
  [Mois], [Pluie (mm)],
  ..pluie.map(l => (l.mois, l.pluie_mm)).flatten(),
  [*Total annuel*], [*#total*],
)

Autres mesures sur l'année :
- évapotranspiration estimée : *500 mm* ;
- débit moyen de la rivière à l'exutoire : *0,8 m³/s*.

#note[Rappel : 1 mm d'eau sur 1 km² = 1 000 m³ ; une année ≈ 31,5 millions de
secondes.]

== Questions

#question[*1.* Calculez le volume total de précipitations reçu par le bassin
sur l'année, en millions de m³.][
  // Décimales françaises en mode math : entre guillemets ("0,8"), sinon
  // Typst traite la virgule comme un séparateur et affiche « 0, 8 ».
  $P = "0,8 m" times 120 times 10^6 thin "m"^2 = 96 times 10^6 thin "m"^3$, soit
  *96 millions de m³*.
]

#question[*2.* Calculez le volume écoulé par la rivière sur l'année, puis
exprimez-le en millimètres sur le bassin.][
  $R = "0,8" times "31,5" times 10^6 approx "25,2" times 10^6 thin "m"^3$.
  Rapporté à la surface : $("25,2" times 10^6) / (120 times 10^6) = "0,21 m"$,
  soit *≈ 210 mm*.
]

#question[*3.* Déduisez-en la lame d'eau infiltrée (ou stockée dans le
sol). Que représente-t-elle en pourcentage des précipitations ?][
  $I = P - E T - R = 800 - 500 - 210 = 90 "mm"$, soit *≈ 11 %* des
  précipitations. Cette eau recharge les nappes souterraines.
]

#question[*4.* La moitié du bassin est urbanisée en 20 ans. Comment
évolueront, selon vous, $R$ et $I$ ?][
  Les surfaces imperméables réduisent l'infiltration : $I$ *diminue* et $R$
  *augmente*. Les crues deviennent plus rapides et plus fortes, et les nappes
  se rechargent moins.
]
