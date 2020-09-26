# Minimal makefile for LaTeX documents
LATEX := pdflatex -halt-on-error

# pdflatex output management
LATEX_OUT_ERROR := | grep -E --color=never '^! |^Output '
LATEX_OUT_QUIET := 2&> /dev/null
LATEX_OUT_CLEAN ?= $(LATEX_OUT_ERROR)

# directories
OUTDIR := output
PRTDIR := print
SRCDIR := source
CLSDIR := theme
IMGDIR := media
ATSDIR := ats

# source files
SRC := $(SRCDIR)/skeleton.tex
# file dependecies
DEPS := faresume.cls \
	$(shell find $(CLSDIR) -name '*.tex') \
	$(shell find $(SRCDIR) -name '*.tex')

# i18 localization
LANGS := en fr

# cv profile
CV_USER := $(shell cat source/header.tex | grep '\author{' | cut -b9- | cut -d'}' -f1 | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
CV_TITLE := $(shell git status | head -n1 | cut -b11-)

# git profile
GIT_REPO := $(shell git remote get-url origin | sed -r 's/((git@|http(s)?:\/\/)([a-zA-Z0-9\-\.@]+)(\/|:))([a-zA-Z0-9_\-]+)\/([[a-zA-Z0-9_\-]+)(.git){0,1}((\/){0,1})/\6\/\7/')
GIT_BRANCH := $(shell git branch --show-current)
GIT_RAW := https://raw.githubusercontent.com/$(GIT_REPO)/$(GIT_BRANCH)

# QR code to be included in the printable document
DEPS += $(foreach LANG, $(LANGS), $(IMGDIR)/$(LANG)-qr.png)

# output documents
DOCS := $(foreach LANG, $(LANGS), $(OUTDIR)/$(CV_USER)-$(CV_TITLE)-$(LANG).pdf)
# printable documents
DOCS += $(DOCS:$(OUTDIR)%=$(PRTDIR)%)

# APS keywords default file
ATSWORDS ?= $(ATSDIR)/keywords.gen

# main recipe
all: info compile mrproper

# TODO info about the current build
info:
	@git status | head -n1
	@echo "Titles:"
	@cat $(SRCDIR)/header.tex | grep '\title{' | cut -b8- | cut -d'}' -f1

compile: $(DOCS)

%-qr.png:
	@qrencode -o $@ "$(GIT_RAW)/$(OUTDIR)/$(CV_USER)-$(CV_TITLE)-$(notdir $(@:%-qr.png=%)).pdf"

# TODO DEPS filtering by lang and print/output
%pdf:$(SRC) $(DEPS)
	@#echo $@: $<
	@TEXINPUTS=$(IMGDIR):$(SRCDIR):$(SRCDIR)/$(subst $(CV_USER)-$(CV_TITLE),resume,$(notdir $(@:%.pdf=%))):$$TEXINPUTS \
		$(LATEX) -jobname=$(notdir $(@:%.pdf=%)) -output-directory=$(patsubst %/,%,$(dir $@)) \
		"\def\is$(notdir $(subst $(CV_USER)-$(CV_TITLE)-,lang,$(@:%.pdf=%))){1} \def\is$(patsubst %/,%,$(dir $@))able{1} \input{$<}" $(LATEX_OUT_CLEAN)
	@TEXINPUTS=$(IMGDIR):$(SRCDIR):$(SRCDIR)/$(subst $(CV_USER)-$(CV_TITLE),resume,$(notdir $(@:%.pdf=%))):$$TEXINPUTS \
		$(LATEX) -jobname=$(notdir $(@:%.pdf=%)) -output-directory=$(patsubst %/,%,$(dir $@)) \
		"\def\is$(notdir $(subst $(CV_USER)-$(CV_TITLE)-,lang,$(@:%.pdf=%))){1} \def\is$(patsubst %/,%,$(dir $@))able{1} \input{$<}" $(LATEX_OUT_QUIET)
	@#echo "ATS keywords matching test for $(notdir $@) (`pdftotext -q $@ - | grep -wio -f $(ATSWORDS) | sort -f | uniq -i | wc -l`/`wc -l $(ATSWORDS)`)"

mrproper:
	@rm -f {$(PRTDIR),$(OUTDIR)}/*.{out,log,aux}

clean:
	@echo 'cleaned'
	@rm -f $(DOCS)

.PHONY: all compile mrproper clean
