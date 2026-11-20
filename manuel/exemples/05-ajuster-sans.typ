#import "/lib/theme.typ": *
#show: gabarit
#set page(height: auto) if est-a4 // capture : page A4 rognée au contenu
// hauteur-site: 1000

= Exemple 5 (sans)

== 😈 Augmenter le coût pour l'attaquant

#synthese[
  - Pyramide de la douleur (David Bianco, 2013)
  - Tous les indicateurs ne se valent pas
]

==== Les six niveaux

Du plus douloureux (sommet) au plus indolore (base) :

#table(
  columns: (5fr, 7fr, auto, 6fr),
  table.header([Niveau], [Indicateur], [Douleur], [Ce que doit faire l'attaquant]),
  [*TTP*], [Tactiques, techniques, procédures], [Très douloureux], [Repenser toute sa méthodologie],
  [*Outils*], [Le logiciel offensif lui-même], [Douloureux], [Redévelopper ou racheter un outil],
  [*Artefacts réseau / hôte*], [User-Agent, motif d'URI, tube nommé, clé de registre], [Ennuyeux], [Reconfigurer l'outil],
  [*Noms de domaine*], [Domaine de C2], [Simple], [Réenregistrer un domaine (propagation DNS)],
  [*Adresses IP*], [IP de C2 / infrastructure], [Trivial], [Changer de VPS, proxy, nœud Tor],
  [*Hash de fichiers*], [Signature d'un fichier exact], [Trivial], [Modifier 1 octet suffit à changer le hash],
)
