# Minimal makefile for LaTeX documents
LATEX := pdflatex -halt-on-error

# pdflatex output management
LATEX_OUT_ERROR := | grep -E --color=never '^! |^Output '
LATEX_OUT_QUIET := 2&> /dev/null
LATEX_OUT_CLEAN ?= $(LATEX_OUT_ERROR)

# directories
OUTDIR := output
PRTDIR := $(OUTDIR)/printable
SRCDIR := source
ATSDIR := ats

# source files
SRC := $(SRCDIR)/cv.tex $(SRCDIR)/resume.tex
# file dependecies
DEPS := faresume.cls

# output documents
DOCS := $(SRC:$(SRCDIR)%tex=$(OUTDIR)%pdf)
# printable documents
DOCS += $(DOCS:$(OUTDIR)%=$(PRTDIR)%)

# APS keywords default file
ATSWORDS ?= $(ATSDIR)/keywords.gen

# main recipe
all: compile mrproper

compile: $(DOCS)

$(OUTDIR)/%pdf:$(SRCDIR)/%tex $(DEPS)
	@$(LATEX) -output-directory=$(patsubst %/,%,$(dir $@)) $< $(LATEX_OUT_CLEAN)
	@$(LATEX) -output-directory=$(patsubst %/,%,$(dir $@)) $< $(LATEX_OUT_QUIET)
	@echo "ATS keywords matching test for $(notdir $@) (`pdftotext -q $@ - | grep -wio -f $(ATSWORDS) | sort -f | uniq -i | wc -l`/`wc -l $(ATSWORDS)`)"

$(PRTDIR)%pdf:$(SRCDIR)%tex $(DEPS)
	@$(LATEX) -output-directory=$(patsubst %/,%,$(dir $@)) "\def\isprintable{1} \input{$<}" $(LATEX_OUT_QUIET)
	@$(LATEX) -output-directory=$(patsubst %/,%,$(dir $@)) "\def\isprintable{1} \input{$<}" $(LATEX_OUT_QUIET)

mrproper:
	@rm -f {$(PRTDIR),$(OUTDIR)}/*.{out,log,aux}

clean:
	@echo 'cleaned'
	@rm -f $(DOCS)

.PHONY: all compile mrproper clean
