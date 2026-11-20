# Thèmes visuels

Six thèmes au choix, sur les trois cibles (A4, slides, site). Le contenu ne
change pas, seul l'habillage change : couleurs, polices, décors.

```bash
make slides THEME=soc          # ou : make a4 THEME=crise, make all THEME=tlp…
typst compile --root docs --input cible=slides --input theme=neon docs/main.typ sortie.pdf
```

Sans `THEME`, c'est le thème **classique**, celui d'origine : il est identique
au pixel près à l'ancien rendu (vérifié sur les 524 pages A4 + slides).

| Thème | Ambiance | Slides | A4 (impression) | Site |
|---|---|---|---|---|
| `classique` | Indigo Material, sobre (thème d'origine) | clair | clair | clair / sombre selon le système |
| `soc` | 🖥️ **SOC de nuit** : console d'analyste, vert phosphore, titres en police console avec invite `>` et curseur | **sombre** | clair, accents verts | toujours sombre, curseur clignotant |
| `crise` | 🚨 **Cellule de crise** : rouge alerte, bande de signalisation jaune/noire, titres en capitales, marque « ⚠ CRISE CYBER » | clair | clair + bande | clair / sombre |
| `tlp` | 🗂️ **Rapport d'incident** : papier crème, titres « machine à écrire », texte à empattements, marquage `TLP:CLEAR` | papier crème | blanc | papier crème |
| `bouclier` | 🛡️ **Blue Team** : bandeau marine plein, bleu électrique, couverture avec grille | clair + bandeau | titres en bandeau marine | clair / sombre |
| `neon` | 😈 **Red Team néon** : violet nuit, magenta et cyan, titres « glitch » en capitales | **sombre** | clair, accents magenta | toujours sombre, effet glitch |

Les thèmes à slides sombres (`soc`, `neon`) gardent un A4 clair : le PDF A4
est fait pour être imprimé.

Les captures ci-dessous viennent de [themes/demo.typ](themes/demo.typ), une
page de démonstration : une synthèse, un encadré, un tableau et une question.
Pour les régénérer : `bash docs/manuel/captures-themes.sh`.

---

## `classique` : Classique (thème actuel)

| Diapo de titre | Diapo de chapitre |
|---|---|
| <img src="themes/classique-slides-1.png" width="440"> | <img src="themes/classique-slides-2.png" width="440"> |
| **Synthèse + encadré** | **Tableau + note** |
| <img src="themes/classique-slides-3.png" width="440"> | <img src="themes/classique-slides-4.png" width="440"> |
| **Question + réponse** | |
| <img src="themes/classique-slides-6.png" width="440"> | |

| A4 : page de titre | A4 : chapitre |
|---|---|
| <img src="themes/classique-a4-1.png" width="360"> | <img src="themes/classique-a4-3.png" width="360"> |

**Site :**

<img src="themes/classique-site.png" width="720">

---

## `soc` : 🖥️ SOC de nuit

| Diapo de titre | Diapo de chapitre |
|---|---|
| <img src="themes/soc-slides-1.png" width="440"> | <img src="themes/soc-slides-2.png" width="440"> |
| **Synthèse + encadré** | **Tableau + note** |
| <img src="themes/soc-slides-3.png" width="440"> | <img src="themes/soc-slides-4.png" width="440"> |
| **Question + réponse** | |
| <img src="themes/soc-slides-6.png" width="440"> | |

| A4 : page de titre | A4 : chapitre |
|---|---|
| <img src="themes/soc-a4-1.png" width="360"> | <img src="themes/soc-a4-3.png" width="360"> |

**Site :**

<img src="themes/soc-site.png" width="720">

---

## `crise` : 🚨 Cellule de crise

| Diapo de titre | Diapo de chapitre |
|---|---|
| <img src="themes/crise-slides-1.png" width="440"> | <img src="themes/crise-slides-2.png" width="440"> |
| **Synthèse + encadré** | **Tableau + note** |
| <img src="themes/crise-slides-3.png" width="440"> | <img src="themes/crise-slides-4.png" width="440"> |
| **Question + réponse** | |
| <img src="themes/crise-slides-6.png" width="440"> | |

| A4 : page de titre | A4 : chapitre |
|---|---|
| <img src="themes/crise-a4-1.png" width="360"> | <img src="themes/crise-a4-3.png" width="360"> |

**Site :**

<img src="themes/crise-site.png" width="720">

---

## `tlp` : 🗂️ Rapport d'incident (TLP)

| Diapo de titre | Diapo de chapitre |
|---|---|
| <img src="themes/tlp-slides-1.png" width="440"> | <img src="themes/tlp-slides-2.png" width="440"> |
| **Synthèse + encadré** | **Tableau + note** |
| <img src="themes/tlp-slides-3.png" width="440"> | <img src="themes/tlp-slides-4.png" width="440"> |
| **Question + réponse** | |
| <img src="themes/tlp-slides-6.png" width="440"> | |

| A4 : page de titre | A4 : chapitre |
|---|---|
| <img src="themes/tlp-a4-1.png" width="360"> | <img src="themes/tlp-a4-3.png" width="360"> |

**Site :**

<img src="themes/tlp-site.png" width="720">

---

## `bouclier` : 🛡️ Blue Team

| Diapo de titre | Diapo de chapitre |
|---|---|
| <img src="themes/bouclier-slides-1.png" width="440"> | <img src="themes/bouclier-slides-2.png" width="440"> |
| **Synthèse + encadré** | **Tableau + note** |
| <img src="themes/bouclier-slides-3.png" width="440"> | <img src="themes/bouclier-slides-4.png" width="440"> |
| **Question + réponse** | |
| <img src="themes/bouclier-slides-6.png" width="440"> | |

| A4 : page de titre | A4 : chapitre |
|---|---|
| <img src="themes/bouclier-a4-1.png" width="360"> | <img src="themes/bouclier-a4-3.png" width="360"> |

**Site :**

<img src="themes/bouclier-site.png" width="720">

---

## `neon` : 😈 Red Team néon

| Diapo de titre | Diapo de chapitre |
|---|---|
| <img src="themes/neon-slides-1.png" width="440"> | <img src="themes/neon-slides-2.png" width="440"> |
| **Synthèse + encadré** | **Tableau + note** |
| <img src="themes/neon-slides-3.png" width="440"> | <img src="themes/neon-slides-4.png" width="440"> |
| **Question + réponse** | |
| <img src="themes/neon-slides-6.png" width="440"> | |

| A4 : page de titre | A4 : chapitre |
|---|---|
| <img src="themes/neon-a4-1.png" width="360"> | <img src="themes/neon-a4-3.png" width="360"> |

**Site :**

<img src="themes/neon-site.png" width="720">

---

## Créer ou retoucher un thème

Tout se trouve en haut de [lib/theme.typ](../lib/theme.typ), dans `_themes`.
Un thème est un dictionnaire de **jetons** qui remplacent les valeurs de
`_base`. On ne donne que ce qui change :

```typst
mon-theme: (
  primaire: rgb("#00695c"),
  couleurs: (note: …, question: …, concept: …, plus: …,
             exemple: …, afaire: …, retenir: …, reponse: …),
  police-titre: ("DejaVu Sans Mono", "Noto Color Emoji"),
  etiquette: [⚑ EXERCICE],                  // marque en haut à droite
  slides: (fond: rgb("#101418"), texte: white, titres: white,
           teinte: (c, n: 0%) => color.mix((c, 15%), (rgb("#101418"), 85%))),
),
```

| Jeton | Rôle |
|---|---|
| `primaire`, `couleurs` | couleur principale, une couleur par type de bloc |
| `police-texte`, `police-titre`, `police-code` | polices (installées dans le conteneur ou dans `fonts/`) |
| `fond`, `texte`, `titres`, `attenue`, `legende`, `filet` | fond de page et couleurs de texte |
| `code-fond`, `code-bord`, `code-ligne`, `table-bord`, `table-zebra`, `table-entete` | code et tableaux |
| `teinte(c)`, `fonce(c)` | fond d'un encadré de couleur `c` ; texte en couleur `c` lisible sur le fond |
| `majuscules`, `titre(c)` | titres en capitales ; décor du titre (préfixe, curseur, effet…) |
| `etiquette` | marque affichée en haut à droite (diapos, en-tête A4, couverture) |
| `decor` | arrière-plan des pages (ex. bande de signalisation de `crise`) |
| `bandeau-diapo` | bandeau plein derrière le titre des diapos (`bouclier`) |
| `fond-titre` | fond plein de la couverture (texte en blanc) |
| `slides: (…)` | jetons remplacés **pour les slides seulement** (ex. fond sombre) |

Pour le **site**, ajoutez un bloc `html.theme-mon-theme { --primaire: …; … }`
à la fin de [lib/site.css](../lib/site.css) : le site ne lit pas les jetons
Typst, mais reçoit la classe `theme-<nom>` sur `<html>`. Le nom du thème est
contrôlé à la compilation : une faute de frappe dans `THEME=…` affiche la liste
des thèmes disponibles.
