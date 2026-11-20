#import "/lib/theme.typ": *
#show: gabarit
#set page(height: auto) if est-a4 // capture : page A4 rognée au contenu

= Exemple 2

== Prioriser les alertes

Une détection « parfaite » sur le papier mais qui produit 95 % de faux
positifs a un coût opérationnel qui dépasse sa valeur 🤯

#diapo[
  *Prioriser* : score de risque = confiance × impact (_risk-based alerting_)
]

#developpement[#note[
  Prioriser les alertes de l'organisation
  - _Confiance_ : probabilité que ce soit réellement malveillant.
  - _Impact potentiel_ : gravité si c'est vrai, pondérée par la criticité de
    l'actif touché (un DC vs un poste de test).
]]
