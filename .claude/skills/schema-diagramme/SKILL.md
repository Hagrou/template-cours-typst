---
name: schema-diagramme
description: Crée ou modifie un schéma intégré au cours Typst Hunting In The Noise (cycle de vie, chaîne d'attaque, architecture SOC, flux sondes → SIEM → SOC...), dessiné en Typst avec le package fletcher, rendu dans l'A4, les slides et le site. Remplace l'ancien skill schema-mermaid (mermaid n'est pas rendu par Typst). À utiliser quand l'utilisateur veut un schéma/diagramme/flowchart pour une page du cours.
---

# Schéma pour le cours

Typst ne rend pas mermaid. Les schémas simples s'écrivent directement en
Typst avec le package [fletcher](https://typst.app/universe/package/fletcher)
(nœuds + flèches), encapsulés dans la fonction `#schema` du thème. Les
schémas riches existants restent en draw.io (`images/*.drawio`, exportés en
PNG pour les PDF et SVG pour le site).

## Quand utiliser fletcher vs draw.io

- **fletcher (`#schema`)** : diagramme simple, qui change souvent,
  versionné en texte dans le `.typ` (flowchart de processus, séquence
  d'attaque courte, cycle en étapes, architecture sondes → SIEM → SOC).
  Choix par défaut : pas de fichier binaire, diff lisible, couleurs et
  police du cours automatiquement, rendu identique sur les 3 cibles.
- **draw.io** : schéma visuellement riche (mise en page précise, icônes,
  légendes complexes), comme le cycle de vie de la détection. Ne pas
  migrer l'existant sans raison. Pour l'intégrer :
  `#illustration("/images/x.drawio.png", web: "/images/x.drawio.svg", alt: "…", largeur: 80%)`
  (le SVG draw.io n'est pas lisible par Typst : texte en `foreignObject`).

## Étapes

1. **Choisir la forme** adaptée au propos :
   - chaîne ou cycle en étapes (6 phases du cycle de vie, kill chain →
     détection → triage → réponse) : nœuds sur une grille, flèches `"-|>"` ;
   - interaction entre acteurs (attaquant / EDR / SIEM / SOC) : acteurs en
     colonnes, échanges en flèches étiquetées ;
   - cartographie d'outils ou d'architecture : nœuds groupés, flèches de
     flux.

2. **Importer fletcher en tête du fichier** (après l'import du thème), dans
   le seul fichier qui l'utilise :

   ```typst
   #import "@preview/fletcher:0.5.8": diagram, node, edge
   ```

   Le package est téléchargé à la première compilation puis mis en cache
   (`~/.cache/typst`, volume Docker `typst-cache` via le Makefile). La
   première compilation demande donc un accès réseau.

3. **Écrire le schéma** dans `#schema` (indispensable : sur le site,
   l'export HTML de Typst ignore les graphiques, `#schema` les intègre en
   SVG ; en PDF il centre et rend le schéma insécable) :

   ```typst
   #schema(legende: [Cycle de vie de la détection (6 phases)])[
     #diagram(
       spacing: (1.4em, 2em),
       node-stroke: 0.8pt + primaire,
       node-fill: primaire.lighten(90%),
       node-corner-radius: 3pt,
       edge-stroke: 0.8pt,
       node((0, 0), [Requirements \ discovery], name: <req>),
       node((1, 0), [Triage], name: <tri>),
       node((2, 0), [Investigate], name: <inv>),
       node((2, 1), [Develop], name: <dev>),
       node((1, 1), [Test], name: <tst>),
       node((0, 1), [Deploy], name: <dep>),
       edge(<req>, <tri>, "-|>"),
       edge(<tri>, <inv>, "-|>"),
       edge(<inv>, <dev>, "-|>"),
       edge(<dev>, <tst>, "-|>"),
       edge(<tst>, <dep>, "-|>"),
       edge(<dep>, <req>, "-|>", [boucle], label-side: left),
     )
   ]
   ```

   Couleurs : utiliser celles du thème (`primaire`, ou
   `couleurs.question`, `couleurs.plus`, `couleurs.exemple`… de
   [lib/theme.typ](/docs/lib/theme.typ)), pas de
   couleurs en dur. Sur le site, le schéma garde un fond blanc en mode
   sombre (cf. `figure.schema` dans `lib/site.css`).

4. **Rester cohérent avec le vocabulaire du cours** (noms des 6 phases
   dans
   [03-ingenierie-detection.typ](/docs/cours/03-ingenierie-detection.typ),
   niveaux de la pyramide de la douleur, etc.) plutôt que d'introduire des
   libellés parallèles pour la même idée.

5. **Insérer le schéma** à l'endroit du texte qu'il illustre (éventuellement
   dans une colonne : `#colonnes[texte][#schema[…]]`).

6. **Vérifier le rendu** : une erreur de syntaxe fait échouer la
   compilation (contrairement à mermaid, rien de silencieux), mais la
   lisibilité se juge à l'œil. Compiler (`make all`, skill `build-check`)
   puis regarder la page A4 et la diapo concernées avec
   `bash .claude/skills/build-check/planche.sh <a4|slides> <page> 1 80`.
   Relire nœuds, flèches et libellés avant de considérer la tâche terminée.

## Points d'attention

- Pas plus d'une dizaine de nœuds par schéma : au-delà, scinder en
  plusieurs schémas ou passer en draw.io pour rester net en slide comme
  en A4.
- Retour à la ligne dans un nœud : `\` (ex. `[Requirements \ discovery]`).
- Dans un chapitre de `cours/`, le schéma est aussi projeté : vérifier qu'il
  tient sur une diapo avec son titre.
