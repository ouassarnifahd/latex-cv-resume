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
DEPS := faresume.cls $(shell find $(SRCDIR) -name '*.tex') $(shell find $(CLSDIR) -name '*.tex')

# i18 localization
LANGS := en fr

# profile
NAME := $(shell cat source/header.tex | grep '\author{' | cut -b9- | cut -d'}' -f1 | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
TITLE := $(shell git status | head -n1 | cut -b11-)

# output documents
DOCS := $(foreach LANG, $(LANGS), $(OUTDIR)/$(NAME)-$(TITLE)-$(LANG).pdf)
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

%pdf:$(SRC) $(DEPS)
	@#echo $@: $<
	@TEXINPUTS=$(IMGDIR):$(SRCDIR):$(SRCDIR)/$(subst $(NAME)-$(TITLE),resume,$(notdir $(@:%.pdf=%))):$$TEXINPUTS \
		$(LATEX) -jobname=$(notdir $(@:%.pdf=%)) -output-directory=$(patsubst %/,%,$(dir $@)) \
		"\def\is$(notdir $(subst $(NAME)-$(TITLE)-,lang,$(@:%.pdf=%))){1} \def\is$(patsubst %/,%,$(dir $@))able{1} \input{$<}" $(LATEX_OUT_CLEAN)
	@TEXINPUTS=$(IMGDIR):$(SRCDIR):$(SRCDIR)/$(subst $(NAME)-$(TITLE),resume,$(notdir $(@:%.pdf=%))):$$TEXINPUTS \
		$(LATEX) -jobname=$(notdir $(@:%.pdf=%)) -output-directory=$(patsubst %/,%,$(dir $@)) \
		"\def\is$(notdir $(subst $(NAME)-$(TITLE)-,lang,$(@:%.pdf=%))){1} \def\is$(patsubst %/,%,$(dir $@))able{1} \input{$<}" $(LATEX_OUT_QUIET)
	@#echo "ATS keywords matching test for $(notdir $@) (`pdftotext -q $@ - | grep -wio -f $(ATSWORDS) | sort -f | uniq -i | wc -l`/`wc -l $(ATSWORDS)`)"

mrproper:
	@rm -f {$(PRTDIR),$(OUTDIR)}/*.{out,log,aux}

clean:
	@echo 'cleaned'
	@rm -f $(DOCS)

.PHONY: all compile mrproper clean
