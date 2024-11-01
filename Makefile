#!/bin/make

########### CONFIGURATION ########################

NAME="webpage.lauria"
REMOTE="massimo@massimolauria.net:/srv/www/massimolauria.net/"
TIME   = $(shell date +%Y%m%d.%H%M)


########### BUILDING PARAMETERS ##################

EMACS=emacs

ifeq ($(shell uname -s),Darwin)
EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
EMACSCLIENT=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
endif


BUILD=site-build
BIBLIO=bibliography

BIBTEX2BIBXML=./$(BIBLIO)/bibtex2bibxml.py
BIBXML2XML=./$(BIBLIO)/bibxml2xml.py
BIBTEMPFILES=$(BIBLIO)/papers.bib.xml $(BIBLIO)/papers.html

########### THE RULES ############################

all: $(BUILD)
	$(EMACS) --batch -l publish.el --eval '(org-publish-project "main" nil)'

$(BUILD): src/index.org src/teaching.org src/research.org $(BIBLIO)/papers.html
	$(EMACS) --batch -l publish.el --eval '(org-publish-project "main" t)'

clean:
	@rm -vrf $(BUILD)
	@rm -vf $(BIBTEMPFILES)

$(BIBLIO)/papers.html: $(BIBLIO)/papers.bib
	$(BIBTEX2BIBXML) $(BIBLIO)/papers.bib >     $(BIBLIO)/papers.bib.xml
	$(BIBXML2XML)    $(BIBLIO)/papers.bib.xml > $(BIBLIO)/papers.html
	@rm -vf $(BIBLIO)/papers.bib.xml

pkg:
	@make clean
	@echo "Building $(NAME).SNAP.$(TIME).tar.gz"
	@$git archive HEAD | gzip -c > ../$(NAME).SNAP.$(TIME).tar.gz 2> /dev/null

deploy: $(BUILD)
	rsync -rvz --chmod='u=rwX,go=rX' $(BUILD)/ $(REMOTE)


.PHONY: all clean pkg deploy
