#import "/lib/theme.typ": *
#show: gabarit
#set page(height: auto) if est-a4 // capture : page A4 rognée au contenu
// hauteur-site: 1280

= Exemple 6

== Questions de positionnement

#question[
  🧩 *1.* Qu'est-ce que le _dwell time_, et pourquoi cherche-t-on à le réduire ?
][
  C'est la durée pendant laquelle l'attaquant est présent dans le SI sans
  être détecté. Plus elle est courte, moins il progresse dans la kill chain.
]

#question[
  🧩 *2.* Le MTTD (Mean Time To Detect) mesure :

  a) Le temps moyen de réponse à un incident \
  b) Le temps moyen de détection d'un incident \
  c) Le temps moyen de remédiation
][
  *b)*, c'est la moyenne du dwell time sur l'ensemble des incidents.
]

#question[
  🧩 *3.* Question ouverte, sans réponse fournie : quelles sources de logs
  avez-vous dans votre SI ?
]

== Réponse et détails isolés

Un `#reponse` ou un `#details` peut aussi s'utiliser seul :

#reponse[Ceci est une réponse isolée (sans question).]

#details("💡 Pour aller plus loin : le MTTR")[
  Le MTTR (Mean Time To Respond) complète le MTTD : il mesure le temps entre
  la détection et la remédiation.
]
