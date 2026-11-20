// =============================================================================
// Hunting In The Noise — thème commun aux 3 cibles de compilation
//
//   typst compile --input cible=a4     main.typ   -> document A4 (PDF)
//   typst compile --input cible=slides main.typ   -> diapositives 16:9 (PDF)
//   typst compile --input cible=site --features html --format html main.typ
//                                                  -> site web (HTML)
//
// Les chapitres n'importent que ce fichier et n'utilisent que les fonctions
// "pédagogiques" ci-dessous (question, reponse, concept, colonnes…) : c'est
// ici, et seulement ici, que l'on décide du rendu selon la cible.
// =============================================================================

#let cible = sys.inputs.at("cible", default: "a4")
#assert(
  cible in ("a4", "slides", "site"),
  message: "cible inconnue : " + cible + " (attendu : a4, slides ou site)",
)
#let est-site = cible == "site"
#let est-slides = cible == "slides"
#let est-a4 = cible == "a4"

// Valeurs par défaut des métadonnées du cours. Chaque cours les remplace dans
// son point d'entrée :
//   #show: gabarit.with(titre: "…", sous-titre: "…", auteur: "…")
#let cours = (
  titre: "Hunting In The Noise",
  sous-titre: "Cours sur la détection d'attaques Cyber",
  auteur: "Philippe Boinot",
)
// Métadonnées effectives (après gabarit.with), pour les fonctions appelées
// hors du gabarit (ex. #partie).
#let _cours = state("cours", cours)

// -----------------------------------------------------------------------------
// Thèmes visuels : --input theme=classique|soc|crise|tlp|bouclier|neon
// -----------------------------------------------------------------------------
// Un thème est un dictionnaire de « jetons » (couleurs, polices, décors) lu
// par tout le rendu PDF ci-dessous. Clé `slides` : jetons remplacés pour les
// diapos seulement (ex. fond sombre en projection, A4 clair pour l'impression).
// Le site reçoit la classe `theme-<nom>` sur <html> (cf. lib/site.css).

#let _sans = ("Noto Sans", "DejaVu Sans", "Noto Color Emoji")
#let _mono = ("DejaVu Sans Mono", "Noto Color Emoji")

#let _base = (
  primaire: rgb("#3f51b5"),
  // Une couleur par type de note pédagogique (cf. emojis en tête de bloc).
  couleurs: (
    note: rgb("#3f51b5"),
    question: rgb("#7c4dff"), // 🧩 question posée au groupe
    concept: rgb("#3f51b5"), //  📐 repère théorique / définition
    plus: rgb("#00897b"), //     🎁 pour aller plus loin
    exemple: rgb("#d81b60"), //  📝 exemple concret
    afaire: rgb("#ff8f00"), //   🚧 point à compléter
    retenir: rgb("#1e88e5"), //  🎯 synthèse (= puces de la diapo)
    reponse: rgb("#43a047"),
  ),
  police-texte: _sans,
  police-titre: _sans,
  police-code: _mono,
  fond: none, //              fond de page (none = blanc)
  texte: luma(0), //          couleur du texte courant
  titres: luma(0), //         couleur des titres de diapo / chapitre
  attenue: luma(110), //      en-têtes, pieds de page, « (suite) »
  legende: luma(90), //       légendes, chemins de fichiers
  filet: luma(200), //        filets fins (en-tête, pied de page)
  code-fond: luma(246),
  code-bord: luma(225),
  code-ligne: luma(240), //   code en ligne
  table-bord: luma(210),
  table-zebra: luma(250),
  teinte: (c, n: 93%) => c.lighten(n), // fond d'un encadré de couleur c (n : éclaircissement)
  fonce: c => c.darken(20%), //   texte en couleur c, lisible sur le fond
  majuscules: false, //       titres de diapo en capitales
  titre: c => c, //           décor du texte d'un titre (préfixe, effet…)
  etiquette: none, //         marque en haut à droite (diapos et A4)
  decor: none, //             décor d'arrière-plan des pages (page.background)
  table-entete: none, //      fond de l'en-tête de tableau (none = primaire éclairci)
  bandeau-diapo: none, //     couleur d'un bandeau plein sous le titre de diapo
  fond-titre: none, //        fond de la diapo / page de titre
)

#let _themes = (
  // Indigo Material, thème d'origine du site MkDocs.
  classique: (separateur: luma(190), suite: luma(120)),

  // 🖥️ SOC de nuit : console d'analyste, vert phosphore sur fond GitHub-dark.
  soc: (
    primaire: rgb("#1a7f37"),
    couleurs: (
      note: rgb("#57606a"), question: rgb("#8250df"), concept: rgb("#0969da"),
      plus: rgb("#1b7c83"), exemple: rgb("#bf3989"), afaire: rgb("#9a6700"),
      retenir: rgb("#1a7f37"), reponse: rgb("#1a7f37"),
    ),
    police-titre: _mono,
    titre: c => [#text(fill: rgb("#3fb950"), weight: "bold")[>]~#c],
    etiquette: text(font: _mono, size: 0.8em)[#text(fill: rgb("#f85149"))[●] SOC · LIVE],
    slides: (
      primaire: rgb("#3fb950"),
      couleurs: (
        note: rgb("#8b949e"), question: rgb("#a371f7"), concept: rgb("#58a6ff"),
        plus: rgb("#39c5cf"), exemple: rgb("#f778ba"), afaire: rgb("#d29922"),
        retenir: rgb("#3fb950"), reponse: rgb("#56d364"),
      ),
      fond: rgb("#0d1117"), texte: rgb("#e6edf3"), titres: rgb("#e6edf3"),
      attenue: rgb("#8b949e"), legende: rgb("#8b949e"), filet: rgb("#30363d"),
      code-fond: rgb("#161b22"), code-bord: rgb("#30363d"), code-ligne: rgb("#21262d"),
      table-bord: rgb("#30363d"), table-zebra: rgb("#161b22"),
      table-entete: rgb("#1f3a27"),
      teinte: (c, n: 0%) => color.mix((c, 16%), (rgb("#0d1117"), 84%)),
      fonce: c => c.lighten(15%),
      titre: c => [#text(fill: rgb("#3fb950"))[>]~#c#text(fill: rgb("#3fb950"))[▌]],
    ),
  ),

  // 🚨 Cellule de crise : rouge alerte, bande de signalisation, titres en capitales.
  crise: (
    primaire: rgb("#c62828"),
    couleurs: (
      note: rgb("#455a64"), question: rgb("#6a1b9a"), concept: rgb("#c62828"),
      plus: rgb("#00695c"), exemple: rgb("#ad1457"), afaire: rgb("#ef6c00"),
      retenir: rgb("#c62828"), reponse: rgb("#2e7d32"),
    ),
    titres: rgb("#1c1c1c"),
    majuscules: true,
    etiquette: box(fill: rgb("#c62828"), inset: (x: 0.5em, y: 0.25em), radius: 2pt,
      text(fill: white, weight: "bold", size: 0.8em, tracking: 0.08em)[⚠ CRISE CYBER]),
    decor: place(top, rect(width: 100%, height: 0.45cm, stroke: none, fill: tiling(
      size: (16pt, 16pt),
      {
        place(rect(width: 16pt, height: 16pt, fill: rgb("#ffc400")))
        place(line(start: (0pt, 16pt), end: (16pt, 0pt), stroke: 5pt + rgb("#1c1c1c")))
        place(line(start: (-8pt, 8pt), end: (8pt, -8pt), stroke: 5pt + rgb("#1c1c1c")))
        place(line(start: (8pt, 24pt), end: (24pt, 8pt), stroke: 5pt + rgb("#1c1c1c")))
      },
    ))),
  ),

  // 🗂️ Rapport d'incident : papier, machine à écrire, marquage TLP.
  tlp: (
    primaire: rgb("#1f3a5f"),
    couleurs: (
      note: rgb("#5c5c5c"), question: rgb("#5b3f8c"), concept: rgb("#1f3a5f"),
      plus: rgb("#2f6f5e"), exemple: rgb("#8c2f39"), afaire: rgb("#b36b00"),
      retenir: rgb("#1f3a5f"), reponse: rgb("#3f6b2a"),
    ),
    police-texte: ("Noto Serif", "DejaVu Serif", "Noto Color Emoji"),
    police-titre: ("Liberation Mono", "DejaVu Sans Mono", "Noto Color Emoji"),
    police-code: ("Liberation Mono", "DejaVu Sans Mono", "Noto Color Emoji"),
    titres: rgb("#1a1a1a"),
    etiquette: box(fill: black, inset: (x: 0.5em, y: 0.3em),
      text(font: "DejaVu Sans Mono", fill: white, weight: "bold", size: 0.8em)[TLP:CLEAR]),
    slides: (
      fond: rgb("#f6f1e4"),
      code-fond: rgb("#efe8d6"), code-ligne: rgb("#e9e1cc"), table-zebra: rgb("#f0eadb"),
      teinte: (c, n: 0%) => color.mix((c, 9%), (rgb("#f6f1e4"), 91%)),
    ),
  ),

  // 🛡️ Blue Team : bandeau marine plein, bleu électrique, grille de fond.
  bouclier: (
    primaire: rgb("#0a2342"),
    couleurs: (
      note: rgb("#0a2342"), question: rgb("#6c4cf1"), concept: rgb("#0077c8"),
      plus: rgb("#00897b"), exemple: rgb("#e0457b"), afaire: rgb("#f59e0b"),
      retenir: rgb("#00a6fb"), reponse: rgb("#10b981"),
    ),
    titres: rgb("#0a2342"),
    titre: c => [#text(fill: rgb("#00a6fb"))[▍]#c],
    bandeau-diapo: rgb("#0a2342"),
    fond-titre: rgb("#0a2342"),
  ),

  // 😈 Red Team néon : fond violet nuit, magenta / cyan, titres « glitch ».
  neon: (
    primaire: rgb("#c2185b"),
    couleurs: (
      note: rgb("#5e548e"), question: rgb("#7b1fa2"), concept: rgb("#00838f"),
      plus: rgb("#00796b"), exemple: rgb("#c2185b"), afaire: rgb("#e65100"),
      retenir: rgb("#00838f"), reponse: rgb("#2e7d32"),
    ),
    police-titre: _mono,
    majuscules: true,
    slides: (
      primaire: rgb("#ff2e88"),
      couleurs: (
        note: rgb("#9e9ac8"), question: rgb("#b388ff"), concept: rgb("#00e5ff"),
        plus: rgb("#64ffda"), exemple: rgb("#ff2e88"), afaire: rgb("#ffd740"),
        retenir: rgb("#00e5ff"), reponse: rgb("#69f0ae"),
      ),
      fond: rgb("#120a1f"), texte: rgb("#ece6ff"), titres: white,
      attenue: rgb("#9e9ac8"), legende: rgb("#9e9ac8"), filet: rgb("#3a2d5c"),
      code-fond: rgb("#1c1230"), code-bord: rgb("#3a2d5c"), code-ligne: rgb("#2a1d45"),
      table-bord: rgb("#3a2d5c"), table-zebra: rgb("#1a1029"),
      table-entete: rgb("#3d1239"),
      teinte: (c, n: 0%) => color.mix((c, 14%), (rgb("#120a1f"), 86%)),
      fonce: c => c.lighten(10%),
      // Effet « glitch » : deux copies décalées, cyan et magenta, sous le titre.
      titre: c => box({
        place(dx: -1.5pt, text(fill: rgb("#00e5ff").transparentize(25%), c))
        place(dx: 1.5pt, text(fill: rgb("#ff2e88").transparentize(25%), c))
        c
      }),
    ),
  ),
)

#let theme-nom = sys.inputs.at("theme", default: "classique")
#assert(
  theme-nom in _themes,
  message: "thème inconnu : " + theme-nom + " (attendu : " + _themes.keys().join(", ") + ")",
)
#let th = {
  let t = _base + _themes.at(theme-nom)
  if est-slides and "slides" in t { t + t.slides } else { t }
}

#let primaire = th.primaire
#let couleurs = th.couleurs
#let police-texte = th.police-texte
#let police-code = th.police-code

// -----------------------------------------------------------------------------
// Blocs pédagogiques
// -----------------------------------------------------------------------------

#let _encadre(type, corps) = if est-site {
  html.elem("blockquote", attrs: (class: "note-" + type), corps)
} else {
  block(
    width: 100%,
    fill: (th.teinte)(couleurs.at(type)),
    stroke: (left: 3pt + couleurs.at(type)),
    radius: (right: 3pt),
    inset: (x: 0.9em, y: 0.65em),
    corps,
  )
}

#let note(corps) = _encadre("note", corps)
#let concept(corps) = _encadre("concept", corps)
#let plus(corps) = _encadre("plus", corps)
#let exemple(corps) = _encadre("exemple", corps)
#let afaire(corps) = _encadre("afaire", corps)

/// Bloc repliable : replié sur le site (<details>), déplié en PDF.
#let details(titre, corps) = if est-site {
  html.elem("details", attrs: (class: "reponse"))[
    #html.elem("summary", titre)
    #corps
  ]
} else {
  block(
    width: 100%,
    fill: (th.teinte)(couleurs.reponse, n: 94%),
    stroke: (left: 3pt + couleurs.reponse),
    radius: (right: 3pt),
    inset: (x: 0.9em, y: 0.65em),
  )[
    #text(fill: (th.fonce)(couleurs.reponse), weight: "bold", titre)
    #v(0.2em, weak: true)
    #corps
  ]
}

#let reponse(corps) = details("Réponse", corps)

// A4 : les réponses sont renvoyées dans un corrigé en fin de chapitre (un PDF
// ne sait pas « déplier » comme le <details> du site). Chaque question est
// mémorisée ici ; _corriges-publier() les écrit puis vide la liste.
#let _q-num = counter("question-a4")
#let _corriges = state("corriges-a4", ())

/// Question au groupe (🧩), suivie de sa réponse éventuelle :
///   #question[Énoncé][Réponse]
/// Site : réponse repliée (<details>). Slides : question et réponse sur la
/// même diapo. A4 : lien « Voir la réponse » vers le corrigé de fin de
/// chapitre, qui renvoie lui-même à la question.
#let question(enonce, ..rep) = {
  let reps = rep.pos()
  if est-site {
    _encadre("question", enonce)
    for r in reps { reponse(r) }
  } else if est-slides {
    if reps.len() == 0 {
      block(breakable: false, width: 100%, _encadre("question", enonce))
    } else {
      // Deux diapos identiques, la seconde avec la réponse en plus : en
      // passant de l'une à l'autre, la réponse semble apparaître (animation).
      // Nouvelle diapo, sauf pour la 1re question sous un titre : elle reste
      // sur la diapo du titre (sinon diapo vide, le bloc de hauteur nulle du
      // titre empêchant le saut « faible » d'être ignoré). Test sur l'ordre du
      // document, pas sur la mise en page, pour éviter qu'il se contredise.
      context {
        let titres = query(heading.where(level: 2).or(heading.where(level: 3)).before(here()))
        let premiere = titres.len() > 0 and query(
          selector(<question-diapo>).after(titres.last().location()).before(here()),
        ).len() == 0
        if not premiere { pagebreak(weak: true) }
      }
      [#metadata(none) <question-diapo>]
      block(breakable: false, width: 100%, _encadre("question", enonce))
      pagebreak()
      [#metadata(none) <diapo-reponse>] // en-tête recopié de la diapo question
      block(breakable: false, width: 100%, {
        _encadre("question", enonce)
        for r in reps { reponse(r) }
      })
      pagebreak(weak: true)
    }
  } else {
    _q-num.step()
    context {
      let n = str(_q-num.get().first())
      let sections = query(heading.where(level: 2).before(here()))
      let section = if sections.len() > 0 { sections.last().body } else { none }
      _corriges.update(l => l + ((n: n, section: section, reps: reps),))
      let vers = label("corrige-" + n)
      block(breakable: false, width: 100%)[
        #metadata(none)#label("question-" + n)
        #_encadre("question", enonce)
        #if reps.len() > 0 {
          if query(vers).len() > 0 {
            // Corrigé publié (document complet) : simple renvoi.
            v(0.25em, weak: true)
            link(vers, text(size: 0.85em, weight: "bold", fill: (th.fonce)(couleurs.reponse))[
              ➜ Voir la réponse (p. #context counter(page).at(vers).first())
            ])
          } else {
            // Pas de corrigé (ex. chapitre prévisualisé seul) : réponse sur place.
            for r in reps { reponse(r) }
          }
        }
      ]
    }
  }
}

/// Écrit le corrigé des questions posées depuis le précédent appel (A4).
#let _corriges-publier() = if est-a4 {
  context {
    let items = _corriges.get()
    if items.any(q => q.reps.len() > 0) {
      // Appelé depuis la règle `show` des titres de niveau 1 : on annule le
      // style hérité du titre (gras, taille, espacement des blocs).
      set text(weight: "regular", size: 10.5pt)
      set block(above: 1.2em, below: 1.2em)
      // Nouvelle page : on ne voit pas les réponses en lisant les questions.
      pagebreak(weak: true)
      heading(level: 2, outlined: false)[Corrigés]
      let courante = auto
      let i = 0
      for q in items {
        if q.section != courante {
          courante = q.section
          i = 0
          if q.section != none { heading(level: 3, outlined: false, q.section) }
        }
        i += 1 // numérotation par section, comme les « *1.* » des énoncés
        if q.reps.len() > 0 {
          [#metadata(none)#label("corrige-" + q.n)]
          details([Réponse #i], {
            for r in q.reps { r }
            v(0.3em, weak: true)
            let retour = label("question-" + q.n)
            align(right, link(retour, text(size: 0.85em, fill: (th.fonce)(couleurs.reponse))[
              ← Retour à la question (p. #context counter(page).at(retour).first())
            ]))
          })
        }
      }
    }
  }
  _corriges.update(())
}

// -----------------------------------------------------------------------------
// Niveau de détail selon la cible (slides synthétiques, A4/site développés)
// -----------------------------------------------------------------------------
//
//   #synthese[- puce courte …]   slides : contenu de la diapo
//                                A4/site : encadré « 🎯 À retenir »
//   #developpement[prose …]      A4/site : texte normal
//                                slides : note de l'orateur (fichier .pdfpc)
//   #diapo[…]                    slides seulement
//   #selon(slides: [court])[long]  variante ponctuelle

/// Contenu converti en texte (Markdown léger) pour les notes de l'orateur.
/// Les éléments non textuels (images, schémas, tableaux, `#voir` évalué en
/// contexte…) sont ignorés.
#let _en-texte(c) = {
  if c == none { return "" }
  if type(c) == str { return c }
  if type(c) != content { return "" }
  let f = c.func()
  if f == text { c.text }
  else if repr(f) == "space" { " " }
  else if f == linebreak { "\n" }
  else if f == parbreak { "\n\n" }
  else if f == smartquote { if c.double { "\"" } else { "'" } }
  else if f == strong { "**" + _en-texte(c.body) + "**" }
  else if f == emph { "_" + _en-texte(c.body) + "_" }
  else if f == raw { "`" + c.text + "`" }
  // Sous-listes : indentées sous l'élément parent.
  else if f == list.item { "\n- " + _en-texte(c.body).trim().replace("\n", "\n  ") }
  else if f == enum.item {
    let n = if c.has("number") and c.number != none { str(c.number) } else { "1" }
    "\n" + n + ". " + _en-texte(c.body).trim().replace("\n", "\n   ")
  }
  else if f == metadata { if type(c.value) == content { _en-texte(c.value) } else { "" } }
  else if f == table or f == image { "" }
  else if c.has("children") { c.children.map(_en-texte).join() }
  else if c.has("child") { _en-texte(c.child) }
  else if c.has("body") { _en-texte(c.body) }
  else if c.has("text") { c.text }
  else { "" }
}

/// Texte développé : affiché en A4 et sur le site ; en slides, devient une
/// note de l'orateur attachée à la diapo où il se trouve.
#let developpement(corps) = if est-slides {
  let note = _en-texte(corps)
    .replace(regex("[ \t]+\n"), "\n")
    // espace en tête de paragraphe, sauf indentation d'une sous-liste
    .replace(regex("\n\n[ \t]+([^\s\-\d])"), m => "\n\n" + m.captures.first())
    .replace(regex("\n{3,}"), "\n\n")
    .trim()
  [#metadata(note) <note-orateur>]
} else {
  corps
}

/// Contenu propre aux slides (accroche, schéma simplifié…).
#let diapo(corps) = if est-slides { corps } else { none }

/// Synthèse : contenu de la diapo en slides, encadré « À retenir » ailleurs.
#let synthese(corps) = if est-slides {
  corps
} else {
  _encadre("retenir", if est-site {
    [*🎯 À retenir* #parbreak() #corps]
  } else {
    block(below: 0.7em, text(fill: (th.fonce)(couleurs.retenir), weight: "bold")[🎯 À retenir])
    corps
  })
}

/// Slides : réduit la taille du texte (jusqu'à 60 %) pour que le contenu tienne
/// dans la place restante de la diapo au lieu de déborder sur la suivante.
/// A4/site : contenu inchangé.
#let ajuster(minimum: 60%, corps) = if est-slides {
  context {
    // Place restante : du point courant jusqu'à la marge basse (cf. gabarit).
    let dispo = page.height - 1.7cm - here().position().y
    let taille = text.size
    layout(zone => {
      let essai(f) = measure(block(width: zone.width, text(size: taille * f, corps))).height
      let facteurs = range(100, int(minimum / 1%) - 1, step: -5).map(p => p / 100)
      let f = facteurs.find(f => essai(f) <= dispo)
      if f == none { f = minimum / 100% }
      block(breakable: false, width: 100%, text(size: taille * f, corps))
    })
  }
} else {
  corps
}

/// Variante ponctuelle : `#selon(slides: [version courte])[version longue]`.
#let selon(slides: none, corps) = if est-slides and slides != none { slides } else { corps }

/// Notes de l'orateur au format pdfpc (lu par pdfpc, pympress…), extraites par
/// `typst query … "<pdfpc>" --field value --one` (cf. Makefile, cible slides).
#let _notes-pdfpc() = context {
  let pages = (:)
  for n in query(<note-orateur>) {
    let p = str(n.location().page())
    pages.insert(p, pages.at(p, default: ()) + (n.value,))
  }
  [#metadata((
    pdfpcFormat: 2,
    disableMarkdown: false,
    pages: pages.pairs().map(((p, notes)) => (
      idx: int(p) - 1,
      label: p,
      overlay: 0,
      forcedOverlay: false,
      hidden: false,
      note: notes.join("\n\n"),
    )),
  )) <pdfpc>]
}

// -----------------------------------------------------------------------------
// Mise en page
// -----------------------------------------------------------------------------

/// Colonnes côte à côte (texte | image…) ; empilées sur écran étroit (site).
#let colonnes(..cols) = if est-site {
  html.elem("div", attrs: (class: "grid"), cols.pos().map(c => html.elem("div", c)).join())
} else {
  grid(
    columns: (1fr,) * cols.pos().len(),
    column-gutter: 1.5em,
    align: horizon,
    ..cols.pos(),
  )
}

/// Image du cours. `chemin` est relatif à la racine du cours (`/images/…`).
/// `web` : variante pour le site (ex. SVG draw.io, dont le texte en
/// foreignObject n'est pas rendu par Typst, d'où un PNG pour les PDF).
#let illustration(chemin, alt: "", largeur: 80%, web: none) = if est-site {
  let src = (if web != none { web } else { chemin }).trim("/", at: start)
  html.elem("figure", attrs: (class: "illustration"))[
    #html.elem("img", attrs: (src: src, alt: alt, style: "width:" + repr(largeur)))
  ]
} else if est-slides {
  align(center, image(chemin, alt: alt, width: largeur, height: 11cm, fit: "contain"))
} else {
  align(center, image(chemin, alt: alt, width: largeur))
}

/// Schéma dessiné en Typst (ex. diagramme fletcher, cf. skill schema-diagramme).
/// Sur le site, l'export HTML ignore les graphiques : on les intègre en SVG.
#let schema(corps, legende: none) = if est-site {
  html.elem("figure", attrs: (class: "schema"))[
    #html.frame(corps)
    #if legende != none { html.elem("figcaption", legende) }
  ]
} else {
  align(center, block(breakable: false)[
    #corps
    #if legende != none { v(0.3em); text(size: 0.85em, fill: th.legende, legende) }
  ])
}

#let separateur() = if est-site {
  html.elem("hr")
} else {
  align(center, line(length: 40%, stroke: 0.5pt + th.at("separateur", default: th.filet)))
}

/// Renvoi vers un autre chapitre (étiquette posée sur son titre).
/// Si le chapitre n'est pas inclus (ex. les approfondissements dans les
/// slides), seul le texte est affiché.
/// (Le `metadata` invisible garde le texte lisible par `_en-texte`, pour les
/// notes de l'orateur : le contenu d'un `context` n'est pas inspectable.)
#let voir(cle, corps) = [#metadata(corps)#context {
  if query(cle).len() == 0 {
    corps
  } else if est-site {
    html.elem("a", attrs: (href: "#" + str(cle)), corps)
  } else {
    link(cle, text(fill: primaire, corps))
  }
}]

/// Lien vers un fichier fourni avec le cours (règles, IOC, archives de TD…),
/// chemin relatif à la racine du cours. Copié à côté du site par le build.
#let fichier(chemin, corps) = if est-site {
  html.elem("a", attrs: (href: chemin), corps)
} else {
  [#corps #text(size: 0.8em, fill: th.legende)[(#raw(chemin))]]
}

/// Intercalaire de partie (Cours, Approfondissements, TD, Ressources).
#let partie(titre) = if est-slides {
  none // une seule partie (Cours) dans les slides
} else if est-site {
  html.elem("div", attrs: (class: "partie"))[#metadata(titre) <partie> #titre]
} else {
  _corriges-publier() // corrigé du dernier chapitre de la partie précédente
  pagebreak(weak: true)
  [#metadata(titre) <partie>]
  set page(header: none, footer: none)
  v(1fr)
  text(size: 11pt, weight: "bold", tracking: 0.1em, fill: primaire, context upper(_cours.get().titre))
  v(0.4em)
  text(size: 34pt, weight: "bold", titre)
  v(0.3em)
  line(length: 30%, stroke: 2pt + primaire)
  v(2fr)
}

// -----------------------------------------------------------------------------
// Règles communes PDF (A4 et slides)
// -----------------------------------------------------------------------------

/// Texte d'un titre habillé selon le thème (police, capitales, décor).
#let _titre(c) = {
  set text(font: th.police-titre)
  (th.titre)(if th.majuscules { upper(c) } else { c })
}

/// Fond de page du thème (`auto` = blanc par défaut de Typst).
#let _fond(f) = if f == none { auto } else { f }

#let _commun(corps) = {
  set text(lang: "fr", font: police-texte, fill: th.texte)
  set par(justify: false)
  show raw: set text(font: police-code)
  show link: set text(fill: primaire)
  show raw.where(block: true): it => block(
    width: 100%,
    fill: th.code-fond,
    stroke: 0.5pt + th.code-bord,
    radius: 3pt,
    inset: 0.7em,
    text(size: 0.85em, it),
  )
  show raw.where(block: false): it => box(
    fill: th.code-ligne,
    inset: (x: 2pt),
    outset: (y: 2pt),
    radius: 2pt,
    it,
  )
  let entete = if th.table-entete == none { primaire.lighten(88%) } else { th.table-entete }
  set table(
    stroke: 0.5pt + th.table-bord,
    inset: 0.45em,
    fill: (_, y) => if y == 0 { entete } else if calc.even(y) { th.table-zebra },
  )
  show table.cell.where(y: 0): set text(weight: "bold")
  show table: set text(size: 0.9em)
  show table: set par(justify: false)
  set list(indent: 0.6em, marker: ([•], [◦], [–]))
  set enum(indent: 0.6em)
  corps
}

// Titre de chapitre courant (pour en-têtes / pieds de page).
#let _chapitre-courant() = {
  let avant = query(heading.where(level: 1).before(here()))
  let ici = query(heading.where(level: 1)).filter(h => h.location().page() == here().page())
  if ici.len() > 0 { ici.first().body } else if avant.len() > 0 { avant.last().body }
}

// -----------------------------------------------------------------------------
// Cible A4
// -----------------------------------------------------------------------------

#let _gabarit-a4(cours, corps) = {
  set document(title: cours.titre, author: cours.auteur)
  set page(
    paper: "a4",
    margin: (x: 2.2cm, top: 2.5cm, bottom: 2.3cm),
    fill: _fond(th.fond),
    background: th.decor,
    header: context {
      let ch = query(heading.where(level: 1)).filter(h => h.location().page() == here().page())
      if ch.len() == 0 {
        set text(size: 8.5pt, fill: th.attenue)
        let cols = (cours.titre, _chapitre-courant()) + if th.etiquette != none { (th.etiquette,) } else { () }
        grid(columns: (1fr,) + (auto,) * (cols.len() - 1), column-gutter: 0.8em, align: horizon, ..cols)
        v(-0.5em)
        line(length: 100%, stroke: 0.4pt + th.filet)
      }
    },
    footer: context {
      set text(size: 8.5pt, fill: th.attenue)
      align(center, counter(page).display())
    },
  )
  set text(size: 10.5pt)
  set par(leading: 0.62em, spacing: 1em)
  show: _commun

  show heading: set block(above: 1.6em, below: 0.8em)
  show heading: set text(fill: th.titres)
  show heading.where(level: 1): it => {
    _corriges-publier() // corrigé du chapitre qui se termine
    pagebreak(weak: true)
    v(1cm)
    block(below: 1.4em)[
      #text(size: 9pt, weight: "bold", tracking: 0.08em, fill: primaire, upper(cours.titre))
      #if th.etiquette != none { h(1fr); th.etiquette }
      #v(0.3em)
      #text(size: 24pt, weight: "bold", _titre(it.body))
    ]
  }
  show heading.where(level: 2): it => if th.bandeau-diapo != none {
    block(
      above: 1.8em,
      below: 0.9em,
      width: 100%,
      fill: th.bandeau-diapo,
      inset: (x: 0.6em, y: 0.45em),
      text(size: 14pt, weight: "bold", fill: white, _titre(it.body)),
    )
  } else {
    block(
      above: 1.8em,
      below: 0.9em,
      width: 100%,
      stroke: (bottom: 0.8pt + primaire.lighten(50%)),
      inset: (bottom: 0.3em),
      text(size: 15pt, weight: "bold", fill: (th.fonce)(primaire), _titre(it.body)),
    )
  }
  show heading.where(level: 3): set text(size: 12.5pt, font: th.police-titre)
  show heading.where(level: 4): set text(size: 11pt)

  // Page de titre
  {
    let clair = th.fond-titre != none
    set text(fill: white) if clair
    page(header: none, footer: none, margin: 3cm, fill: _fond(th.fond-titre))[
      #if th.etiquette != none { align(right, th.etiquette) }
      #v(1fr)
      #text(size: 11pt, weight: "bold", tracking: 0.1em, fill: if clair { white } else { primaire }, upper("Support de cours"))
      #v(0.5em)
      #text(size: 38pt, weight: "bold", fill: if clair { white } else { th.titres }, _titre(cours.titre))
      #v(0.2em)
      #line(length: 35%, stroke: 2.5pt + if clair { couleurs.retenir } else { primaire })
      #v(0.6em)
      #text(size: 15pt, cours.sous-titre)
      #v(2fr)
      #text(size: 11pt, cours.auteur)
    ]
  }

  // Sommaire
  {
    show outline.entry.where(level: 1): set text(weight: "bold")
    show outline.entry.where(level: 1): set block(above: 1.1em)
    outline(title: [Sommaire], depth: 1, indent: auto)
  }
  corps
  _corriges-publier() // corrigé du dernier chapitre
}

// -----------------------------------------------------------------------------
// Cible slides (16:9)
// -----------------------------------------------------------------------------
// Une diapositive par titre de niveau 1 à 3. Le titre des niveaux 2-3 est
// dessiné dans l'en-tête (zone réservée) : un contenu trop long continue sur
// la diapo suivante, qui reprend le titre suivi de « (suite) ».

#let _gabarit-slides(cours, corps) = {
  let marge-x = 1.6cm
  let bandeau = th.bandeau-diapo != none
  set document(title: cours.titre + " — diapositives", author: cours.auteur)
  set page(
    paper: "presentation-16-9",
    margin: (x: marge-x, top: 3cm, bottom: 1.7cm),
    fill: _fond(th.fond),
    background: {
      th.decor
      if th.etiquette != none and not bandeau {
        place(top + right, dx: -marge-x, dy: 0.7cm, text(size: 12pt, th.etiquette))
      }
    },
    header-ascent: 0.5cm,
    header: context {
      let titres = query(heading.where(level: 1).or(heading.where(level: 2)).or(heading.where(level: 3)))
      // Diapo « réponse » : même en-tête que la diapo question qui la précède.
      let reponse-ici = query(<diapo-reponse>).any(m => m.location().page() == here().page())
      let page = here().page() - if reponse-ici { 1 } else { 0 }
      let ici = titres.filter(h => h.location().page() == page)
      let avant = titres.filter(h => h.location().page() < page)
      let (titre, suite) = if ici.len() > 0 { (ici.first(), false) } else if avant.len() > 0 { (avant.last(), true) } else { (none, false) }
      if titre != none and not (titre.level == 1 and not suite) {
        let corps-titre = text(
          size: if titre.level == 3 { 22pt } else { 25pt },
          weight: "bold",
          fill: if bandeau { white } else { th.titres },
        )[
          #_titre(titre.body)
          #if suite { text(size: 0.55em, weight: "regular", fill: if bandeau { white.darken(25%) } else { th.at("suite", default: th.attenue) })[(suite)] }
        ]
        if bandeau {
          // Bandeau plein, à fond perdu jusqu'au bord haut de la diapo.
          block(
            width: 100%,
            fill: th.bandeau-diapo,
            outset: (x: marge-x, top: 3cm, bottom: 0.2cm),
            stroke: (bottom: 3pt + couleurs.retenir),
            corps-titre,
          )
        } else {
          block(width: 100%, stroke: (bottom: 2pt + primaire), inset: (bottom: 0.3em), corps-titre)
        }
      }
    },
    footer: context {
      set text(size: 9pt, fill: th.attenue)
      line(length: 100%, stroke: 0.5pt + th.filet)
      v(-0.4em)
      grid(
        columns: (1fr, auto),
        [#cours.titre — #_chapitre-courant()],
        [#counter(page).display() / #counter(page).final().first()],
      )
    },
  )
  set text(size: 20pt)
  set par(leading: 0.55em, spacing: 0.8em)
  show: _commun
  show table: set text(size: 0.8em)
  // Un tableau qui tient sur une diapo n'est pas coupé (sinon il continue).
  show table: it => layout(taille => {
    let h = measure(it, width: taille.width).height
    if h < 11cm { block(breakable: false, it) } else { it }
  })
  show raw.where(block: true): set text(size: 0.85em)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(-1.2cm)
    text(size: 13pt, weight: "bold", tracking: 0.1em, fill: primaire, upper(cours.titre))
    v(0.2em)
    text(size: 34pt, weight: "bold", fill: th.titres, _titre(it.body))
    v(0.2em)
    line(length: 30%, stroke: 2.5pt + primaire)
    v(0.6em)
  }
  // Titre affiché par l'en-tête de page ; ici seulement le saut de diapo.
  show heading.where(level: 2).or(heading.where(level: 3)): it => {
    pagebreak(weak: true)
    block(height: 0pt, above: 0pt, below: 0pt)
  }
  show heading.where(level: 4): it => text(size: 21pt, fill: th.titres, font: th.police-titre, it)

  // Diapo de titre
  {
    let clair = th.fond-titre != none
    set text(fill: white) if clair
    page(
      header: none,
      footer: none,
      fill: _fond(if clair { th.fond-titre } else { th.fond }),
      background: if clair {
        // Grille discrète (réseau / plan de bataille) sur le fond plein.
        rect(width: 100%, height: 100%, stroke: none, fill: tiling(size: (28pt, 28pt), {
          place(line(start: (0pt, 0pt), end: (28pt, 0pt), stroke: 0.4pt + white.transparentize(88%)))
          place(line(start: (0pt, 0pt), end: (0pt, 28pt), stroke: 0.4pt + white.transparentize(88%)))
        }))
      } else { th.decor },
    )[
      #if th.etiquette != none { align(right, text(size: 12pt, th.etiquette)) }
      #v(1fr)
      #text(size: 40pt, weight: "bold", fill: if clair { white } else { th.titres }, _titre(cours.titre))
      #v(0.2em)
      #line(length: 30%, stroke: 3pt + if clair { couleurs.retenir } else { primaire })
      #v(0.4em)
      #text(size: 20pt, cours.sous-titre)
      #v(1fr)
      #text(size: 14pt, fill: if clair { white.darken(20%) } else { th.legende }, cours.auteur)
    ]
  }
  corps
  _notes-pdfpc()
}

// -----------------------------------------------------------------------------
// Cible site (HTML, export expérimental de Typst)
// -----------------------------------------------------------------------------

#let _id-titre(h) = if h.has("label") {
  str(h.label)
} else {
  "s-" + str(query(selector(heading).before(h.location(), inclusive: false)).len())
}

#let _navigation(cours) = context {
  let elems = query(selector(<partie>).or(heading.where(level: 1)).or(heading.where(level: 2)))
  let lien(h) = html.elem("a", attrs: (href: "#" + _id-titre(h)), h.body)
  let items = ()
  let i = 0
  while i < elems.len() {
    let e = elems.at(i)
    if e.func() == metadata {
      items.push(html.elem("li", attrs: (class: "nav-partie"), e.value))
      i += 1
    } else if e.level == 1 {
      let sous = ()
      i += 1
      while i < elems.len() and elems.at(i).func() == heading and elems.at(i).level == 2 {
        sous.push(html.elem("li", lien(elems.at(i))))
        i += 1
      }
      items.push(html.elem("li")[
        #html.elem("details")[
          #html.elem("summary", lien(e))
          #html.elem("ul", sous.join())
        ]
      ])
    } else {
      i += 1
    }
  }
  html.elem("nav", attrs: (class: "sommaire"))[
    #html.elem("p", attrs: (class: "nav-titre"), cours.titre)
    #html.elem("ul", items.join())
  ]
}

#let _gabarit-site(cours, corps) = {
  set text(lang: "fr")
  // Formules : l'export HTML de Typst 0.13 les ignore, on les intègre en SVG
  // (centrées pour une formule en bloc, dans la ligne sinon).
  show math.equation.where(block: true): it => html.elem("div", attrs: (class: "formule"), html.frame(it))
  show math.equation.where(block: false): it => html.elem("span", attrs: (class: "formule"), html.frame(it))
  show heading: it => context {
    html.elem("h" + str(calc.min(it.level + 1, 6)), attrs: (id: _id-titre(it)), it.body)
  }
  html.elem("html", attrs: (lang: "fr", class: "theme-" + theme-nom))[
    #html.elem("head")[
      #html.elem("meta", attrs: (charset: "utf-8"))
      #html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1"))
      #html.elem("title", cours.titre)
      #html.elem("link", attrs: (rel: "stylesheet", href: "style.css"))
    ]
    #html.elem("body")[
      #html.elem("header", attrs: (class: "bandeau"))[
        #html.elem("a", attrs: (href: "#"), cours.titre)
        #html.elem("span", cours.sous-titre)
      ]
      #html.elem("div", attrs: (class: "page"))[
        #_navigation(cours)
        #html.elem("main", corps)
      ]
    ]
  ]
}

// -----------------------------------------------------------------------------
// Point d'entrée : #show: gabarit
// -----------------------------------------------------------------------------

//   #show: gabarit                              métadonnées par défaut (ci-dessus)
//   #show: gabarit.with(titre: "…", sous-titre: "…", auteur: "…")
#let gabarit(corps, titre: none, sous-titre: none, auteur: none) = {
  let c = cours
  if titre != none { c.titre = titre }
  if sous-titre != none { c.sous-titre = sous-titre }
  if auteur != none { c.auteur = auteur }
  let corps = [#_cours.update(c)#corps]
  if est-site {
    _gabarit-site(c, corps)
  } else if est-slides {
    _gabarit-slides(c, corps)
  } else {
    _gabarit-a4(c, corps)
  }
}
