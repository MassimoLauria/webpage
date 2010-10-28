#!/bin/make

########### CONFIGURATION ########################
SITE="webpage.sapienza"
TIME   = $(shell date +%Y%m%d.%H%M)


SITEMAP=index writings teaching research downloads labprog2010
DATAMAP=css images sw documents

TARGET_ACCOUNT="lauria@pegasus.dsi.uniroma1.it:~/public_html/"
GATE_HOST     ="lauria@gate.di.uniroma1.it"
GATE_ACCOUNT  ="lauria@gate.di.uniroma1.it:~/site-cache/"
GATE_DEPLOYMENT_SCRIPT ="~/pegasus-deploy.sh"

########### BUILDING PARAMETERS ##################

XSLTPROC=xsltproc
BIBTEX2BIBXML=./src/bibtex2bibxml.py
BIBXML2XML=./src/bibxml2xml.py
STYLESHEET=base
TAR=tar
MV=mv
SCP=scp
SSH=ssh
GIT=git

BUILD=site-build
SRC=src
CONTENT=content

WEBPAGES= $(addprefix $(BUILD)/, $(addsuffix .html, $(SITEMAP)))
DATADIR = $(addprefix $(CONTENT)/,$(DATAMAP))

TEMPFILES=$(SRC)/papers.bib.xml $(SRC)/papers.xml $(SRC)/latex2xhtml.pyc

########### THE RULES ############################
TARGET= $(WEBPAGES)

all: $(TARGET)
	@cp -avr $(addprefix $(CONTENT)/,$(DATAMAP)) $(BUILD)

clean:
	@rm -vf $(TARGET)
	@rm -vfr $(addprefix $(BUILD)/,$(DATAMAP))
	@rm -vf $(TEMPFILES)

$(BUILD)/%.html: $(SRC)/%.xml $(SRC)/xsl/$(STYLESHEET).xsl $(SRC)/papers.xml
	$(XSLTPROC) -o $@ $(SRC)/xsl/$(STYLESHEET).xsl $<

$(SRC)/papers.bib.xml: $(SRC)/papers.bib
	$(BIBTEX2BIBXML) $(SRC)/papers.bib > $(SRC)/papers.bib.xml

$(SRC)/papers.xml: $(SRC)/papers.bib.xml
	$(BIBXML2XML) $(SRC)/papers.bib.xml > $(SRC)/papers.xml

snap:
	@make clean
	@echo "Building $(SITE).SNAP.$(TIME).tar.gz"
	@$(GIT) archive HEAD | gzip -c > ../$(SITE).SNAP.$(TIME).tar.gz 2> /dev/null

fulldeploy:
	@echo "Deploying website: you will be asked for a password"
	@cd $(BUILD) && \
	$(SCP) -1 -r "." $(TARGET_ACCOUNT)

htmldeploy:
	@echo "Deploying website: you will be asked for a password"
	@cd $(BUILD) && \
	$(SCP) -1 -r *.html css/ $(TARGET_ACCOUNT)

gatedeploy:
	@echo "This make  command is broken."
	@echo "Deploying website (throught GATE): you will be asked for passwords up to three times."
	@echo "Uploading files on GATE machine... (1) GATE password."
	@echo cd $(BUILD) && $(SCP) -r "." $(GATE_ACCOUNT)
	@echo "Executing remote deploying script... (1) GATE pass first (2) SERVER pass."
	@echo $(SSH) $(GATE_HOST) $(GATE_DEPLOYMENT_SCRIPT)

.PHONY: all clean pkg
