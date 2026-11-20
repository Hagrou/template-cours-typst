#import "/lib/theme.typ": *
#show: gabarit
#set page(height: auto) if est-a4 // capture : page A4 rognée au contenu

= Exemple 3

== 😈 Augmenter le coût pour l'attaquant

#colonnes[
  #selon(slides: [
    🧐 *Le défenseur doit maximiser le coût de contournement.*

    - tous les indicateurs ne se valent pas ;
    - la valeur vient de ceux qui sont coûteux à modifier.
  ])[
    🧐 L'adversaire doit contourner la détection (identifier ce qui est
    difficile à changer pour lui) : *le défenseur doit donc maximiser ce coût !*

    Créée par *David Bianco en 2013*, la Pyramide de la douleur classe les
    indicateurs de compromission selon *la douleur qu'ils infligent à
    l'adversaire quand on les détecte*.

    - Tous les indicateurs ne se valent pas (bloquer des centaines d'IP donne
      un sentiment de productivité, mais l'attaquant en change en minutes).
    - La vraie valeur défensive vient des indicateurs coûteux à modifier.
  ]
][
  #illustration("/images/pyramide-de-la-douleur.svg", alt: "La Pyramide de la douleur", largeur: 90%)
]
