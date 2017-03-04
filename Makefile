#!/bin/make

########### CONFIGURATION ########################
SITE="webpage.lauria"
TIME   = $(shell date +%Y%m%d.%H%M)

COURSES=2010-Labprog-Uniroma1
SITEMAP=index writings teaching research downloads ${COURSES}
DATAMAP=css images sw documents

TARGET_ACCOUNT="massimo@46.101.177.90"              # Digital Ocean Host
#TARGET_ACCOUNT="lauria@login1.lsi.upc.edu"         # UPC
#TARGET_ACCOUNT="lauria@u-shell.csc.kth.se"         # KTH
#TARGET_ACCOUNT="lauria@wwwusers.di.uniroma1.it"    # DI Roma
#TARGET_ACCOUNT="lauria@matsrv.math.cas.cz"         # Math Institute Prague

# GATE_HOST     ="lauria@gate.di.uniroma1.it"
# GATE_ACCOUNT  ="lauria@gate.di.uniroma1.it:~/site-cache/"
# GATE_DEPLOYMENT_SCRIPT ="~/pegasus-deploy.sh"

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
CONTENT=content

BIBTEX2BIBXML=./$(SRC)/bibtex2bibxml.py
BIBXML2XML=./$(SRC)/bibxml2xml.py

DEPLOYFULL=../$(SRC)/fulldeploy.ftp
DEPLOYHTML=../$(SRC)/htmldeploy.ftp


WEBPAGES= $(addprefix $(BUILD)/, $(addsuffix .html, $(SITEMAP)))
DATADIR = $(addprefix $(CONTENT)/,$(DATAMAP))

TEMPFILES=$(SRC)/papers.bib.xml $(SRC)/papers.xml

########### THE RULES ############################
TARGET= $(WEBPAGES)

all: $(TARGET)
	@cp -av $(addprefix $(CONTENT)/,$(DATAMAP)) $(BUILD)

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
	$(SFTP) -o "BatchMode=no" -b $(DEPLOYFULL) $(TARGET_ACCOUNT)

htmldeploy:
	@echo "Deploying website: you will be asked for a password"
	@cd $(BUILD) && \
	$(SFTP) -o "BatchMode=no" -b $(DEPLOYHTML) $(TARGET_ACCOUNT)


# gatedeploy:
# 	@echo "This make  command is broken."
# 	@echo "Deploying website (throught GATE): you will be asked for passwords up to three times."
# 	@echo "Uploading files on GATE machine... (1) GATE password."
# 	@echo cd $(BUILD) && $(SCP) -r "." $(GATE_ACCOUNT)
# 	@echo "Executing remote deploying script... (1) GATE pass first (2) SERVER pass."
# 	@echo $(SSH) $(GATE_HOST) $(GATE_DEPLOYMENT_SCRIPT)

.PHONY: all clean pkg
