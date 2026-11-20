#import "/lib/theme.typ": *

= {{Titre du module}} <NN-titre> // étiquette = nom du fichier sans .typ

*{{Accroche en une phrase : ce que le module change concrètement pour le stagiaire.}}*

== Objectifs

- {{Ce que le stagiaire saura faire à la fin, verbe d'action}}
- {{…}}

== Plan

1. {{Section 1}}
2. {{Section 2}}
3. Auto-évaluation

== Questions de positionnement

#question[
  🧩 *1.* {{Question d'accroche posée aux stagiaires pour amorcer la réflexion}}
][
  {{Réponse attendue, courte.}}
]

== {{Première section, définition / cadrage}}

#synthese[
  - {{3 à 5 puces courtes : ce qui est projeté en diapo}}
  - {{(« 🎯 À retenir » en A4 et sur le site)}}
]

#developpement[
  {{Contenu complet : A4 et site ; notes de l'orateur en slides. Rester
  direct et concret ; privilégier phrases courtes et exemples.}}
]

#concept[
  📐 {{Repère théorique / vocabulaire clé à retenir.}}
]

== ➡️ {{Section de contenu, un sous-thème par titre ==}}

{{Développement. Tableau pour les comparatifs et cycles/étapes, comme dans
02-bonne-detection.typ et 03-ingenierie-detection.typ :}}

#table(
  columns: (auto, 1fr),
  table.header([Élément], [Explication]),
  [{{élément}}], [{{explication}}],
)

#exemple[
  📝 *Exemple — fil rouge {{cas concret}}* : {{illustration de la notion qui
  précède, sur un seul et même cas concret pour toute la page.}}
]

== ⚙️ {{Section pratique / cycle / processus, si pertinent}}

{{…}}

== 🎯 TP / mise en pratique

{{Si le module comporte un TP : objectif, outils utilisés (Atomic Red Team,
Caldera, Splunk BOTS, Malware-Traffic-Analysis…), livrable attendu. Renvoyer
vers l'énoncé avec #voir(<td_...>)[…] s'il existe dans td/.}}

#afaire[
  🚧 {{Point encore à compléter, explicité plutôt que laissé vide.}}
]

#plus[
  🎁 _Pour aller plus loin_ : {{ressource externe}} \
  #link("{{url}}")
]

== Auto évaluation

#question[
  🧩 *1.* {{Question de synthèse}}
][
  {{Réponse}}
]

== Références

- [1] {{Référence bibliographique}}
- {{Lien externe (MITRE ATT&CK, DFIR Report, Sigma, Splunk research…)}} : #link("{{url}}")
