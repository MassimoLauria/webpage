#!/bin/make

########### CONFIGURATION ########################

NAME="webpage.lauria"
REMOTE="massimo@massimolauria.net:/srv/www/massimolauria.net/"
TIME   = $(shell date +%Y%m%d.%H%M)

COURSES=2010-Labprog-Uniroma1
SITEMAP=index writings teaching research downloads ${COURSES}
DATAMAP=css images sw documents



########### BUILDING PARAMETERS ##################

STYLESHEET=base

TAR=tar
MV=mv
SCP=scp
SSH=ssh
GIT=git
SFTP=sftp
XSLTPROC=xsltproc


BUILD=site-build
SRC=src
BIBLIO=bibliography
CONTENT=content

BIBTEX2BIBXML=./$(BIBLIO)/bibtex2bibxml.py
BIBXML2XML=./$(BIBLIO)/bibxml2xml.py

DEPLOYFULL=../$(SRC)/fulldeploy.ftp
DEPLOYHTML=../$(SRC)/htmldeploy.ftp


WEBPAGES= $(addprefix $(BUILD)/, $(addsuffix .html, $(SITEMAP)))
DATADIR = $(addprefix $(CONTENT)/,$(DATAMAP))

TEMPFILES=$(BIBLIO)/papers.bib.xml $(BIBLIO)/papers.html

########### THE RULES ############################
TARGET= $(WEBPAGES)

all: $(TARGET)
	@cp -av $(addprefix $(CONTENT)/,$(DATAMAP)) $(BUILD)

clean:
	@rm -vf $(TARGET)
	@rm -vfr $(addprefix $(BUILD)/,$(DATAMAP))
	@rm -vf $(TEMPFILES)

$(BUILD)/%.html: $(SRC)/%.xml $(SRC)/xsl/$(STYLESHEET).xsl $(BIBLIO)/papers.html
	$(XSLTPROC) -o $@ $(SRC)/xsl/$(STYLESHEET).xsl $<

$(BIBLIO)/papers.html: $(BIBLIO)/papers.bib
	$(BIBTEX2BIBXML) $(BIBLIO)/papers.bib >     $(BIBLIO)/papers.bib.xml
	$(BIBXML2XML)    $(BIBLIO)/papers.bib.xml > $(BIBLIO)/papers.html
	@rm -vf $(BIBLIO)/papers.bib.xml

pkg:
	@make clean
	@echo "Building $(NAME).SNAP.$(TIME).tar.gz"
	@$(GIT) archive HEAD | gzip -c > ../$(NAME).SNAP.$(TIME).tar.gz 2> /dev/null

fulldeploy:
	@echo "Deploying website: you will be asked for a password"
	@cd $(BUILD) && \
	$(SFTP) -o "BatchMode=no" -b $(DEPLOYFULL) $(REMOTE)

htmldeploy:
	@echo "Deploying website: you will be asked for a password"
	@cd $(BUILD) && \
	$(SFTP) -o "BatchMode=no" -b $(DEPLOYHTML) $(REMOTE)


.PHONY: all clean pkg htmldeploy fulldeploy
