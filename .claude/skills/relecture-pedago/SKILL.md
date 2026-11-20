---
name: relecture-pedago
description: Relit une ou plusieurs pages du cours Typst Hunting In The Noise pour la cohérence pédagogique (niveau de langue, structure, présence de questions/TP, alignement avec le plan des 3 jours, usage des encadrés et emojis conventionnels). À utiliser avant de considérer un module "fini", ou quand l'utilisateur demande une relecture/révision d'une page.
---

# Relecture pédagogique

Relit une page existante du cours (`docs/**.typ`).
Pas une simple relecture orthographique : l'objectif est la cohérence avec
le reste du cours et l'efficacité pédagogique pour un stagiaire.

## Grille de relecture

1. **Alignement avec le plan.** La page correspond-elle à un thème du plan
   des 3 jours (J1 fondamentaux & trafic réseau / J2 SIEM & corrélation /
   J3 SOC augmenté par IA), tableau de
   [cours/programme.typ](/docs/cours/programme.typ) ?
   Si le contenu dévie du programme annoncé, le signaler plutôt que de
   corriger silencieusement l'un ou l'autre.

2. **Structure.** Présence d'une accroche (souvent un `#question[🧩 …]` en
   ouverture, cf.
   [03-ingenierie-detection.typ](/docs/cours/03-ingenierie-detection.typ)),
   de titres `==`/`===` qui découpent le propos en unités courtes, d'une
   section de synthèse ou de références en fin de page.
   **Pour un chapitre de `cours/`**, penser aussi aux slides : chaque
   `==`/`===` ouvre une diapo, une section très longue sans sous-titre
   produira une suite de diapos « (suite) » (cf. skill `build-slides`).
   Vérifier que les sections longues ont une `#synthese[…]` (points clés,
   affichés en diapo) et un `#developpement[…]` (prose, passée en notes de
   l'orateur), que la synthèse dit bien l'essentiel du développement, et
   qu'aucune `#question` n'est enfermée dans un `#developpement` (elle
   disparaîtrait des slides).

3. **Densité et niveau de langue.** Le cours privilégie des phrases
   courtes, directes, peu de blabla théorique non ancré (comparer avec
   [02-bonne-detection.typ](/docs/cours/02-bonne-detection.typ)
   qui va droit au fait). Repérer les paragraphes trop longs, les tournures
   verbeuses, le jargon non expliqué à sa première occurrence.

4. **Usage cohérent des conventions du cours** (fonctions de
   [lib/theme.typ](/docs/lib/theme.typ)) :
   - encadrés à valeur fixe, la fonction et l'emoji de tête doivent
     concorder :

     | Fonction | Emoji | Sens |
     |---|---|---|
     | `#question[…][Réponse]` | 🧩 | question posée au groupe (réponse en 2e argument) |
     | `#concept[…]` | 📐 | repère théorique / définition à retenir |
     | `#plus[…]` | 🎁 | pour aller plus loin |
     | `#exemple[…]` | 📝 | exemple concret illustrant la notion qui précède |
     | `#afaire[…]` | 🚧 | point identifié comme incomplet |
     | `#note[…]` | (aucun) | encadré neutre |
     | `#synthese[…]` | 🎯 (ajouté par le thème) | points clés : diapo en slides, « À retenir » en A4/site |

     Signaler tout usage qui détourne ces conventions (un `#afaire` pour
     autre chose qu'un manque à combler, un `#note` qui commence par 🧩 au
     lieu d'un `#question`, une question dont la réponse est dans un
     `#reponse` séparé au lieu du 2e argument…) ;
   - **le « fil rouge »** : quand plusieurs `#exemple[📝 …]` se suivent sur
     une même page (typiquement une notion découpée en étapes/phases), les
     rattacher à **un seul et même cas concret** plutôt que d'inventer un
     exemple différent à chaque fois. Cf. le dump LSASS filé à travers les
     6 phases du cycle de vie de la détection dans
     [03-ingenierie-detection.typ](/docs/cours/03-ingenierie-detection.typ),
     qui reprend le cas d'école de
     [attack_lsass.typ](/docs/approfondissements/attack_lsass.typ)
     (les deux se renvoient l'une à l'autre via `#voir`). Rappeler
     explicitement le fil rouge à chaque occurrence (« Exemple — fil rouge
     dump LSASS ») ;
   - tableaux (`#table`) pour les comparatifs/étapes plutôt que des listes
     imbriquées quand la structure s'y prête ;
   - emojis thématiques de titres tirés de la palette du
     [README du cours](/docs/README.md), sans
     surcharge (un ou deux par page suffit généralement).

5. **Présence d'un ancrage pratique.** Le cours est orienté TP (sections
   « TP de validation » des approfondissements, Atomic Red Team, Splunk
   BOTS, Malware-Traffic-Analysis). Une page purement théorique sans lien
   vers un exercice, un outil ou un cas concret est un signal à remonter,
   pas nécessairement à corriger soi-même.

6. **Marqueurs 🚧 non résolus.** Lister les `#afaire[🚧 …]` : ce sont les
   tâches restantes les plus fiables du cours, à remonter en priorité. Pour
   proposer une résolution, préférer un ou plusieurs `#exemple[📝 …]`
   (rattachés au fil rouge, point 4) plutôt qu'un simple retrait du 🚧.

7. **Liens et références.** Les `#voir(<…>)` et `#fichier(…)` pointent-ils
   vers une cible existante (`bash .claude/skills/build-check/verif-cours.sh`
   le vérifie) ? Les références externes ([1], `#link`) sont-elles
   présentes et plausibles (pas d'affirmation non sourcée sur un TTP, un
   chiffre, un Event ID) ?

## Format du rapport

Ne pas réécrire la page directement sauf demande explicite. Restituer une
liste priorisée :
- **À corriger** : incohérences factuelles, liens cassés, contradictions
  avec d'autres pages.
- **À compléter** : marqueurs 🚧, sections orphelines de TP/exemple. Si une
  proposition de contenu est demandée, la donner sous forme de
  `#exemple[📝 …]` en Typst, rattachés à un fil rouge unique si plusieurs
  se suivent, pas en texte libre hors convention.
- **Suggestions de style** : reformulations, découpage, tableaux,
  proposées, pas imposées.

Terminer par la liste des 🚧 trouvés dans la page, avec leur ligne, comme
rappel actionnable.
