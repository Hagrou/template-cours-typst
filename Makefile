IMAGE   = typst-dev
# Moteur de conteneurs : podman par défaut (make ENGINE=docker pour revenir à Docker).
ENGINE ?= podman
# Le volume typst-cache garde les packages @preview (ex. fletcher) entre deux runs.
# :z relabellise le montage pour SELinux (Fedora) ; sans effet ailleurs.
VOLS  = -v "$(CURDIR)":/workspace:z -v typst-cache:/root/.cache/typst
RUN   = $(ENGINE) run --rm $(VOLS) $(IMAGE)

# Déjà dans le conteneur (Dev Container) : typst est sur le PATH, on l'appelle
# directement au lieu de relancer un conteneur.
ifneq ($(wildcard /.dockerenv /run/.containerenv),)
RUN :=
endif

# =============================================================================
# Cours : un source Typst, trois cibles (A4, slides, site)
# =============================================================================
#
#   make all                          cours par défaut (COURS=exemple-eau)
#   make all COURS=mon-cours          un autre cours (docs/mon-cours/main.typ)
#   make cours                        liste les cours disponibles
#   make nouveau COURS=mon-cours      crée docs/mon-cours/ à partir de l'exemple
#   make help                         aide
#
# Après `make nouveau`, changer les métadonnées de gabarit.with(…) dans
# docs/mon-cours/main.typ, puis remplacer les chapitres.
#
# Cibles : a4, slides (+ notes .pdfpc), site, all, release, watch.
# Sorties : target/<COURS>/<COURS>.pdf, <COURS>-slides.pdf (+ .pdfpc), site/
# Variables :
#   COURS    dossier du cours sous docs/, qui contient main.typ
#            (défaut : exemple-eau)
#   THEME    classique (défaut), soc, crise, tlp, bouclier, neon
#            (cf. docs/manuel/themes.md)
#   CIBLE    cible de `make watch` et `make build` : a4 (défaut), slides
#   VERSION  suffixe de l'archive de `make release` (défaut : date du jour)
#
# Tous les chemins des sources sont relatifs à docs/ (racine Typst : les
# imports "/lib/theme.typ" et les images "/…" en dépendent).

DOCS    = docs
THEME   ?= classique
CIBLE   ?= a4
VERSION ?= $(shell date +%Y%m%d)
COURS   ?= exemple-eau

# Tout le cours est dans docs/<COURS>/ ; ses sorties dans target/<COURS>/.
SRC = $(DOCS)/$(COURS)/main.typ
NOM = $(COURS)
OUT = target/$(COURS)

TYPST   = typst compile --root $(DOCS) --input theme=$(THEME)
RELEASE = $(NOM)-$(VERSION)

.PHONY: help image build shell fonts cours nouveau verif-src \
        all a4 slides site release watch clean clean-preview

help:
	@sed -n '/^#   make all /,/^#   VERSION/p' $(firstword $(MAKEFILE_LIST)) | sed 's/^# \{0,1\}//'
	@echo "Autres cibles : image, shell, fonts, build F=<fichier.typ>, clean, clean-preview"

# --- Environnement -----------------------------------------------------------
image:  ; $(ENGINE) build -t $(IMAGE) -f Dockerfile .
shell:  ; $(ENGINE) run --rm -it $(VOLS) $(IMAGE) bash
fonts:  ; $(RUN) typst fonts

# Compile un fichier isolé (chapitre, TD…) pour le prévisualiser :
#   make build F=docs/exemple-eau/cours/02-etapes.typ [CIBLE=slides]
#   -> target/preview/02-etapes.pdf
F ?= $(SRC)
build:
	@mkdir -p target/preview
	$(RUN) $(TYPST) --input cible=$(CIBLE) $(F) target/preview/$(basename $(notdir $(F))).pdf

# Cours disponibles : dossiers de docs/ qui contiennent un main.typ.
cours:
	@for f in $(DOCS)/*/main.typ; do [ -f "$$f" ] && d=$${f#$(DOCS)/} && printf '%-12s %s\n' "$${d%/main.typ}" "$$f"; done; true

# Nouveau cours copié de l'exemple. Les chemins absolus des sources
# ("/exemple-eau/images/…", #fichier("exemple-eau/…")) sont réécrits vers
# le nouveau dossier.
MODELE = exemple-eau
nouveau:
	@[ "$(origin COURS)" = "command line" ] && [ "$(COURS)" != "$(MODELE)" ] || { echo "Usage : make nouveau COURS=mon-cours"; exit 1; }
	@echo "$(COURS)" | grep -qE '^[a-z0-9][a-z0-9_-]*$$' || { echo "Nom invalide : $(COURS) (minuscules, chiffres, - et _)"; exit 1; }
	@[ ! -e $(DOCS)/$(COURS) ] || { echo "$(DOCS)/$(COURS) existe déjà"; exit 1; }
	cp -r $(DOCS)/$(MODELE) $(DOCS)/$(COURS)
	grep -rlZ '$(MODELE)' $(DOCS)/$(COURS) | xargs -0 -r sed -i 's#$(MODELE)#$(COURS)#g'
	@echo "Cours créé : $(DOCS)/$(COURS)/ — compiler avec : make all COURS=$(COURS)"

verif-src:
	@test -f $(SRC) || { echo "Cours introuvable : $(SRC) (voir make cours)"; exit 1; }

# --- Cibles de compilation ---------------------------------------------------
all: a4 slides site

a4: verif-src
	@mkdir -p $(OUT)
	$(RUN) $(TYPST) --input cible=a4 $(SRC) $(OUT)/$(NOM).pdf

slides: verif-src
	@mkdir -p $(OUT)
	$(RUN) $(TYPST) --input cible=slides $(SRC) $(OUT)/$(NOM)-slides.pdf
	# Notes de l'orateur (#developpement) : fichier pdfpc lu par pdfpc / pympress
	$(RUN) typst query --root $(DOCS) --input theme=$(THEME) --input cible=slides $(SRC) "<pdfpc>" --field value --one > $(OUT)/$(NOM)-slides.pdfpc

# Export HTML de Typst : encore expérimental (avertissement attendu).
site: verif-src
	@rm -rf $(OUT)/site && mkdir -p $(OUT)/site
	$(RUN) $(TYPST) --features html --format html --input cible=site $(SRC) $(OUT)/site/index.html
	cp $(DOCS)/lib/site.css $(OUT)/site/style.css
	# Ressources du cours (images, fichiers de TD…) à leur chemin relatif à
	# docs/, celui écrit dans les sources (#illustration, #fichier)
	cd $(DOCS) && find $(COURS) -type f ! -name '*.typ' -exec cp --parents {} $(CURDIR)/$(OUT)/site/ \;

# Archive diffusable : un dossier racine <NOM>-<VERSION>/ dans le zip.
# zip est fourni par l'image (Dockerfile) : refaire `make image` si besoin.
release: all
	rm -rf $(OUT)/release/$(RELEASE) $(OUT)/release/$(RELEASE).zip
	mkdir -p $(OUT)/release/$(RELEASE)
	cp $(OUT)/$(NOM).pdf $(OUT)/$(NOM)-slides.pdf $(OUT)/$(NOM)-slides.pdfpc \
	   $(OUT)/release/$(RELEASE)/
	cp -r $(OUT)/site $(OUT)/release/$(RELEASE)/site
	$(RUN) sh -c 'cd $(OUT)/release && zip -qr $(RELEASE).zip $(RELEASE)'
	rm -rf $(OUT)/release/$(RELEASE)
	@echo "Archive : $(OUT)/release/$(RELEASE).zip"

# Recompilation continue d'une cible PDF : make watch [COURS=…] CIBLE=slides
watch: verif-src
	@mkdir -p $(OUT)
	$(RUN) typst watch --root $(DOCS) --input theme=$(THEME) --input cible=$(CIBLE) $(SRC) $(OUT)/$(NOM)-$(CIBLE).pdf

clean:
	rm -rf target

# PDF exportés par la preview VS Code (tinymist.outputPath, cf. .vscode/settings.json)
clean-preview:
	rm -rf target/preview
