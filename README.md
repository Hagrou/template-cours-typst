# Course template / Typst version

This framework lets you build a course with *Typst* and produce 3 formats from a single source:

- a website
- a course book (PDF)
- slides (PDF), along with a file of speaker notes for each slide (.pdfpc).

> Note: building the slides also generates, next to the PDF, a speaker-notes file ([pdfpc](https://pdfpc.github.io/) format).
> At least 2 viewers support this format (presenter screen + notes):
> - pdfpc
> - pympress


## Build environment (podman)

The course build environment relies on a container (docker or podman) that holds all the tools needed for compilation. To build the container, run from the host (`make image`):

```sh
$ make image        # builds the typst-dev image (once, or after changing the Dockerfile)
$ make a4           # compiles inside the container
$ make shell        # interactive shell inside the container
```

Each course is a `docs/<course>/` folder containing its own `main.typ`;
`COURS=<course>` selects it (default: `exemple-eau`). Outputs go to
`target/<course>/`.

| Command (repository root) | Produces |
|---|---|
| `make a4` | `target/<course>/<course>.pdf`, full A4 document (title page, table of contents, all parts) |
| `make slides` | `target/<course>/<course>-slides.pdf`, 16:9 slides, "Cours" part only, + `.pdfpc` (speaker notes) |
| `make site` | `target/<course>/site/`, HTML website (`index.html` + `style.css`, images, exercise files), viewable over `file://` |
| `make all` | all three |
| `make all COURS=my-course` | all three, for the course `docs/my-course/` |
| `make release` | `target/<course>/release/<course>-<date>.zip`, archive containing the A4 PDF, the slides (+ `.pdfpc`) and the site; `make release VERSION=1.0` to name the version |
| `make watch CIBLE=slides` | continuous recompilation of a PDF target |
| `make slides THEME=soc` | same, with a visual theme: `classique` (default), `soc`, `crise`, `tlp`, `bouclier`, `neon`, see [manuel/themes.md](manuel/themes.md) |
| `make nouveau COURS=my-course` | creates `docs/my-course/` by copying the example (internal paths rewritten) |
| `make build F=<file.typ>` | compiles a single file into `target/preview/` (chapter preview) |
| `make cours`, `make help` | list of courses, help |

The target is passed to Typst via `--input cible=a4|slides|site`. Typst's HTML
export is still experimental (`--features html`), hence the warning shown
during compilation.

> Notes:
> - The repository is mounted on `/workspace` with the `:z` option (SELinux
>   relabel, required on Fedora); the `typst-cache` volume keeps the
>   `@preview` packages (e.g. fletcher) between builds.
> - To use Docker instead: `make ENGINE=docker image a4`.
> - Already inside the container (Dev Container): `make` calls `typst` directly.
>   To open the Dev Container with podman in VS Code, set
>   `"dev.containers.dockerPath": "podman"`.

## Directory layout

```
main.typ                 entry point: chapter order, parts
lib/theme.typ            all rendering, per target (the only file to touch for formatting)
lib/site.css             website stylesheet (copied as style.css)
cours/                   course chapters (the only ones included in the slides)
images/                  illustrations (+ .drawio sources)
...
```

## Framework user guide

An illustrated user guide for the framework is available here: [manuel.md](manuel.md).

A **complete example course**, "Le cycle de l'eau" (the water cycle), shows every
feature of the template in context (3 chapters + 1 exercise session, about fifteen
slides): [exemple-eau/main.typ](exemple-eau/main.typ). Compile it with
`make all` (output in `target/exemple-eau/`). To start a new
course: `make nouveau COURS=my-course`, then change the metadata in
`gabarit.with(…)` in `docs/my-course/main.typ`.

### Writing conventions

Each chapter starts with `#import "/lib/theme.typ": *` and uses:

| Typst | MkDocs equivalent | Rendering |
|---|---|---|
| `#question[Prompt][Answer]` | `> 🧩 …` followed by `??? Réponse` | site: collapsible answer; slides: question slide, then question + answer slide; A4: link to an answer key at the end of the chapter |
| `#reponse[…]`, `#details("Title")[…]` | standalone `??? Réponse` / `??? type "Title"` | collapsible on the site, expanded in PDF |
| `#concept[…]` `#plus[…]` `#exemple[…]` `#afaire[…]` `#note[…]` | `> 📐` `> 🎁` `> 📝` `> 🚧` `>` | colored box depending on the type |
| `#colonnes[…][…]` | `<div class="grid" markdown>` | two columns (stacked on mobile) |
| `#illustration("/images/x.png", alt: "…", largeur: 80%)` | `<img src=… style="width:80%">` | `web:` allows a variant for the site |
| `#schema(legende: […])[#diagram(…)]` | ` ```mermaid ` block | fletcher diagram (see the `schema-diagramme` skill), SVG on the site |
| `#voir(<td_lsass>)[text]` | `[text](td/td_lsass.md)` | internal cross-reference; plain text if the target is not included (slides) |
| `#voir(<06-SOC-Orga:le-blue-team-funnel>)[…]` | `[…](06-SOC-Orga.md#le-blue-team-funnel)` | cross-reference to a section (label placed on its heading) |
| `#fichier("td/provision-td.ps1")[text]` | link to a provided file | link on the site, path displayed in PDF |

### Level of detail per target

The slides are more concise than the A4 and the site. Within the same chapter:

| Typst | A4 / site | Slides |
|---|---|---|
| `#synthese[- short bullets]` | "🎯 À retenir" (key takeaways) box | slide content |
| `#developpement[full text]` | normal text | **speaker note** (nothing on the slide) |
| `#diapo[…]` | absent | displayed |
| `#selon(slides: [short])[long]` | long version | short version |
| `#ajuster[…]` | unchanged | text shrunk (down to 60%) to fit in the remaining space on the slide |



Without these blocks, content is displayed identically on all three targets: you
can condense a chapter progressively. Full example:
[cours/02-bonne-detection.typ](cours/02-bonne-detection.typ).

#### Example 1: standard section (summary + development)

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

| Target | Rendering |
|---|---|
| A4 / site | blue "🎯 À retenir" box (the 3 bullets), then the full text and the `#note` box |
| Slides | one slide with the 3 bullets; the text of the `#developpement` (bullets, paragraph, note) goes into that slide's speaker notes |

#### Example 2: adding a line on the slide only

Useful when the development goes into the notes but the slide must keep the
main idea:

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

#### Example 3: short version of a block that must stay in place

Inside a layout (here text | image), `#selon` replaces the text without
touching the rest:

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

#### Example 4: entire subsection reserved for the written material

A heading placed inside `#developpement` disappears from the slides (along with its slide);
its text, heading included, becomes the note of the previous slide:

```typst
#developpement[
==== Lecture des niveaux

- *Hash*, un hash identifie un fichier exact…
- *IP*, rotation quasi gratuite d'infrastructure.
]
```

#### Practical rules

- 🧩 questions (`#question`) stay **outside** `#developpement`: they
  have their own slide rendering (question slide, then answer slide).
- Short tables and diagrams are already concise: keep them outside
  `#developpement`, they would not appear in the notes (text only).
- `#voir(…)` works inside a `#developpement`: the link text is kept
  in the note.
- A summary of 3 to 5 short bullets fits on one slide; beyond that, the slide
  continues on a second one, titled "(suite)" (continued).

## Emoji palette (course illustration)

Working palette, to copy/paste as you write slides and pages.

🧐🤩🥳🤯🤬⭐🍭🎲🔫🧬🎁

| Use | Emojis |
|---|---|
| Attacker / offensive | 😈 🥷 🏴‍☠️ 💀 🎣 🪝 🧨 💣 🦠 🐛 🔓 🚩 |
| Detection / hunting | 🔍 🕵️ 🧐 👁️ 📡 🛰️ 🐝 🧵 🔦 🗺️ 🧭 |
| Defense / response | 🛡️ 🔒 🚧 🧯 🚒 🩹 ⛑️ 🧱 🔗 |
| Signal vs noise | 📈 📉 📊 〰️ 🔊 🔇 🌫️ 🎚️ 🎛️ |
| Alert / verdict | 🚨 ⚠️ ❗ ✅ ❌ ⛔ 🟢 🟡 🔴 🏷️ |
| Logs / data / SIEM | 🪵 📜 🗃️ 🗄️ 🧾 💾 🧮 🔢 ⏱️ 🕰️ |
| Tools / automation | 🔧 ⚒️ ⚙️ 🛠️ 🤖 🪄 🧰 🔌 🧪 ⛏️ |
| AI / agent / LLM | 🤖 🧠 ✨ 🪄 💡 🗣️ 🧑‍💻 |
| Process / flow | ➡️ ⤴️ 🔁 🔃 🔀 ⏭️ 🪜 🚦 🧷 📌 |
| Teaching / landmarks | 🎯 🧩 ♟️ 📣 💬 💭 🗯️ 📝 🔑 ⏳ 🏁 🎓 ❓ |
| Impact / criticality | 🔥 💥 ⚡ 🧬 💎 👑 🏭 💰 🩸 |
| Mood / weather (threat level) | ☀️ ⛅ 🌤️ 🌦️ ⛈️ ☔ 🌨️ 🌩️ 🌫️ |
