# Template de cours / version Typst

Ce framework permet de construire un cours à base de *Typst* et permet à partir d'une seule source, de produire 3 formats :

- un site web
- un livre de cours (pdf)
- des slides (pdf) avec également un fichier de commentaires sur chaque slides (.pdfpc).


> Notes : la production de slides génère, à côté du PDF, un format de commentaires (format [pdfpc](https://pdfpc.github.io/). 
> Il existe au moins 2 visionneuses qui prennent ce format (écran présentateur + notes):
> - pdfpc    
> - pympress


## Environnement de compilation (podman)

L'environnement de production du cours repose sur un container (docker ou podman) qui contient l'ensemble des outils nécessaires à la compilation. Pour construire le container, il suffit de faire depuis l'hôte (`make image`) :

```sh
$ make image        # construit l'image typst-dev (une fois, ou après modification du Dockerfile)
$ make a4           # compile dans le conteneur
$ make shell        # shell interactif dans le conteneur
```

Chaque cours est un dossier `docs/<cours>/` qui contient son `main.typ` ;
`COURS=<cours>` le choisit (défaut : `exemple-eau`). Les sorties vont dans
`target/<cours>/`.

| Commande (racine du dépôt) | Produit |
|---|---|
| `make a4` | `target/<cours>/<cours>.pdf`, document A4 complet (page de titre, sommaire, toutes les parties) |
| `make slides` | `target/<cours>/<cours>-slides.pdf`, diapositives 16:9, partie « Cours » seulement, + `.pdfpc` (notes de l'orateur) |
| `make site` | `target/<cours>/site/`, site HTML (`index.html` + `style.css`, images, fichiers de TD), consultable en `file://` |
| `make all` | les trois |
| `make all COURS=mon-cours` | les trois, pour le cours `docs/mon-cours/` |
| `make release` | `target/<cours>/release/<cours>-<date>.zip`, archive contenant le PDF A4, les slides (+ `.pdfpc`) et le site ; `make release VERSION=1.0` pour nommer la version |
| `make watch CIBLE=slides` | recompilation continue d'une cible PDF |
| `make slides THEME=soc` | même chose avec un thème visuel : `classique` (défaut), `soc`, `crise`, `tlp`, `bouclier`, `neon`, cf. [manuel/themes.md](manuel/themes.md) |
| `make nouveau COURS=mon-cours` | crée `docs/mon-cours/` en copiant l'exemple (chemins internes réécrits) |
| `make build F=<fichier.typ>` | compile un fichier isolé dans `target/preview/` (prévisualisation d'un chapitre) |
| `make cours`, `make help` | liste des cours, aide |

La cible est passée à Typst par `--input cible=a4|slides|site`. L'export HTML
de Typst est encore expérimental (`--features html`), d'où l'avertissement
affiché à la compilation.

> Notes : 
>   - Le dépôt est monté sur `/workspace` avec l'option `:z` (relabel SELinux,
  nécessaire sous Fedora) ; le volume `typst-cache` conserve les packages
  `@preview` (ex. fletcher) entre deux compilations.
>   - Pour utiliser Docker à la place : `make ENGINE=docker image a4`.
>   - Déjà dans le conteneur (Dev Container) : `make` appelle `typst` directement.
  Pour ouvrir le Dev Container avec podman dans VS Code, régler
  `"dev.containers.dockerPath": "podman"`.

## Arborescence

```
main.typ                 point d'entrée : ordre des chapitres, parties
lib/theme.typ            tout le rendu, par cible (seul fichier à toucher pour la mise en forme)
lib/site.css             feuille de style du site (copiée en style.css)
cours/                   chapitres du cours (les seuls repris dans les slides)
images/                  illustrations (+ sources .drawio)
...
```

## Mode d'emploi du framework

Un mode d'emploi illustré du framework est disponible ici : [manuel.md](manuel.md).

Un **exemple de cours complet**, « Le cycle de l'eau », montre toutes les
fonctions du template en situation (3 chapitres + 1 TD, une quinzaine de
diapos) : [exemple-eau/main.typ](exemple-eau/main.typ). Le compiler avec
`make all` (résultat dans `target/exemple-eau/`). Pour démarrer un nouveau
cours : `make nouveau COURS=mon-cours`, puis changer les métadonnées de
`gabarit.with(…)` dans `docs/mon-cours/main.typ`.

### Conventions d'écriture

Chaque chapitre commence par `#import "/lib/theme.typ": *` et utilise :

| Typst | Équivalent MkDocs | Rendu |
|---|---|---|
| `#question[Énoncé][Réponse]` | `> 🧩 …` suivi de `??? Réponse` | site : réponse repliable ; slides : diapo question puis diapo question + réponse ; A4 : renvoi vers un corrigé en fin de chapitre |
| `#reponse[…]`, `#details("Titre")[…]` | `??? Réponse` / `??? type "Titre"` isolé | repliable sur le site, déplié en PDF |
| `#concept[…]` `#plus[…]` `#exemple[…]` `#afaire[…]` `#note[…]` | `> 📐` `> 🎁` `> 📝` `> 🚧` `>` | encadré coloré selon le type |
| `#colonnes[…][…]` | `<div class="grid" markdown>` | deux colonnes (empilées sur mobile) |
| `#illustration("/images/x.png", alt: "…", largeur: 80%)` | `<img src=… style="width:80%">` | `web:` permet une variante pour le site |
| `#schema(legende: […])[#diagram(…)]` | bloc ` ```mermaid ` | schéma fletcher (cf. skill `schema-diagramme`), SVG sur le site |
| `#voir(<td_lsass>)[texte]` | `[texte](td/td_lsass.md)` | renvoi interne ; texte simple si la cible n'est pas incluse (slides) |
| `#voir(<06-SOC-Orga:le-blue-team-funnel>)[…]` | `[…](06-SOC-Orga.md#le-blue-team-funnel)` | renvoi vers une section (étiquette posée sur son titre) |
| `#fichier("td/provision-td.ps1")[texte]` | lien vers un fichier fourni | lien sur le site, chemin affiché en PDF |

### Niveau de détail selon la cible

Les slides sont plus synthétiques que l'A4 et le site. Dans un même chapitre :

| Typst | A4 / site | Slides |
|---|---|---|
| `#synthese[- puces courtes]` | encadré « 🎯 À retenir » | contenu de la diapo |
| `#developpement[texte complet]` | texte normal | **note de l'orateur** (rien sur la diapo) |
| `#diapo[…]` | absent | affiché |
| `#selon(slides: [court])[long]` | version longue | version courte |
| `#ajuster[…]` | inchangé | texte réduit (jusqu'à 60 %) pour tenir dans la place restante de la diapo |



Sans ces blocs, un contenu s'affiche à l'identique sur les trois cibles : on
peut condenser un chapitre progressivement. Exemple complet :
[cours/02-bonne-detection.typ](cours/02-bonne-detection.typ).

#### Exemple 1 : section type (synthèse + développement)

```typst
== ➡️ Réduire le _dwell time_ (mean time to detection)

#synthese[
  - *Dwell time* : présence non détectée de l'attaquant dans le SI
  - *MTTD* : moyenne du dwell time sur tous les incidents
  - Objectif : passer de « semaines » à « heures »
]

#developpement[
  - *Dwell time* = durée pendant laquelle l'attaquant est présent dans le SI
    sans être détecté (de la compromission initiale à la détection).
  - Le *MTTD (Mean Time To Detect)* est sa moyenne sur l'ensemble des incidents.

  Plus le dwell time est court, moins l'attaquant a le temps de progresser.

  #note[C'est la métrique de résultat d'un programme de détection.]
]
```

| Cible | Rendu |
|---|---|
| A4 / site | encadré bleu « 🎯 À retenir » (les 3 puces), puis le texte complet et l'encadré `#note` |
| Slides | une diapo avec les 3 puces ; le texte du `#developpement` (puces, paragraphe, note) va dans les notes de l'orateur de cette diapo |

#### Exemple 2 : ajouter une ligne sur la diapo seulement

Utile quand le développement passe en note mais que la diapo doit garder
l'idée maîtresse :

```typst
#diapo[
  *Prioriser* : score de risque = confiance × impact (_risk-based alerting_)
]

#developpement[#note[
  Prioriser les alertes de l'organisation
  - _Confiance_ : probabilité que ce soit réellement malveillant…
  - _Impact potentiel_ : gravité si c'est vrai, pondérée par la criticité de l'actif…
]]
```

#### Exemple 3 : version courte d'un bloc qui doit rester en place

Dans une mise en page (ici texte | image), `#selon` remplace le texte sans
toucher au reste :

```typst
#colonnes[
  #selon(slides: [
    🧐 *Le défenseur doit maximiser le coût de contournement.*
    - tous les indicateurs ne se valent pas ;
    - la valeur vient de ceux qui sont coûteux à modifier.
  ])[
    🧐 L'adversaire doit contourner la détection… (paragraphes complets,
    historique de la Pyramide de la douleur, lien vers l'article de D. Bianco)
  ]
][
  #illustration("/images/pyramide-de-la-douleur.svg", alt: "La Pyramide de la douleur")
]
```

#### Exemple 4 : sous-section entière réservée à l'écrit

Un titre placé dans `#developpement` disparaît des slides (avec sa diapo) ;
son texte, titre compris, devient la note de la diapo précédente :

```typst
#developpement[
==== Lecture des niveaux

- *Hash*, un hash identifie un fichier exact…
- *IP*, rotation quasi gratuite d'infrastructure.
]
```

#### Règles pratiques

- Les questions 🧩 (`#question`) restent **hors** de `#developpement` : elles
  ont leur propre rendu en slides (diapo question puis diapo réponse).
- Les tableaux courts et les schémas sont déjà synthétiques : les laisser hors
  de `#developpement`, ils n'apparaîtraient pas dans les notes (texte seul).
- `#voir(…)` fonctionne dans un `#developpement` : le texte du lien est repris
  dans la note.
- Une synthèse de 3 à 5 puces courtes tient sur une diapo ; au-delà, la diapo
  continue sur une seconde, titrée « (suite) ».

## Palette d'emojis (illustration du cours)

Palette de travail, copier/coller au fil des slides et des pages.

🧐🤩🥳🤯🤬⭐🍭🎲🔫🧬🎁

| Usage | Emojis |
|---|---|
| Attaquant / offensif | 😈 🥷 🏴‍☠️ 💀 🎣 🪝 🧨 💣 🦠 🐛 🔓 🚩 |
| Détection / chasse | 🔍 🕵️ 🧐 👁️ 📡 🛰️ 🐝 🧵 🔦 🗺️ 🧭 |
| Défense / réponse | 🛡️ 🔒 🚧 🧯 🚒 🩹 ⛑️ 🧱 🔗 |
| Signal vs bruit | 📈 📉 📊 〰️ 🔊 🔇 🌫️ 🎚️ 🎛️ |
| Alerte / verdict | 🚨 ⚠️ ❗ ✅ ❌ ⛔ 🟢 🟡 🔴 🏷️ |
| Logs / données / SIEM | 🪵 📜 🗃️ 🗄️ 🧾 💾 🧮 🔢 ⏱️ 🕰️ |
| Outils / automatisation | 🔧 ⚒️ ⚙️ 🛠️ 🤖 🪄 🧰 🔌 🧪 ⛏️ |
| IA / agent / LLM | 🤖 🧠 ✨ 🪄 💡 🗣️ 🧑‍💻 |
| Process / flux | ➡️ ⤴️ 🔁 🔃 🔀 ⏭️ 🪜 🚦 🧷 📌 |
| Pédagogie / repères | 🎯 🧩 ♟️ 📣 💬 💭 🗯️ 📝 🔑 ⏳ 🏁 🎓 |❓
| Impact / criticité | 🔥 💥 ⚡ 🧬 💎 👑 🏭 💰 🩸 |
| Ambiance / méteo (niveau de menace) | ☀️ ⛅ 🌤️ 🌦️ ⛈️ ☔ 🌨️ 🌩️ 🌫️ |

