// Démonstration des thèmes (cf. docs/manuel/captures-themes.sh)
#import "/lib/theme.typ": *
#show: gabarit
#set page(height: auto) if est-a4 // capture : page A4 rognée au contenu

= Comment créer une bonne détection ?

== ➡️ Réduire le _dwell time_

#synthese[
  - *Dwell time* : présence non détectée de l'attaquant dans le SI
  - *MTTD* : moyenne du dwell time sur tous les incidents
  - Objectif : passer de « semaines » à « heures »
]

#exemple[📝 Accès mémoire à `lsass.exe` par un processus non signé → alerte *haute confiance*.]

#developpement[
  Plus le dwell time est court, moins l'attaquant a le temps de progresser.
]

== 😈 La Pyramide de la douleur

#table(
  columns: (auto, 1fr, auto),
  table.header([Niveau], [Ce que doit faire l'attaquant], [Douleur]),
  [*TTP*], [Repenser toute sa méthodologie], [Très douloureux],
  [*Outils*], [Redévelopper ou racheter un outil], [Douloureux],
  [*Adresses IP*], [Changer de VPS, proxy, nœud Tor], [Trivial],
  [*Hash*], [Modifier 1 octet suffit], [Trivial],
)

#note[Viser le *haut* de la pyramide : `Sigma` sur le comportement, pas sur le hash.]

== Questions de positionnement

#question[
  🧩 *1.* Le MTTD (Mean Time To Detect) mesure :

  a) Le temps moyen de réponse à un incident \
  b) Le temps moyen de détection d'un incident
][
  *b)*, c'est la moyenne du dwell time sur l'ensemble des incidents.
]
