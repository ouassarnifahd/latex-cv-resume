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
IMGDIR := media
ATSDIR := ats

# source files
SRC := $(SRCDIR)/skeleton.tex
# file dependecies
DEPS := faresume.cls

# output documents
DOCS := $(OUTDIR)/resume.pdf $(OUTDIR)/cv.pdf
# printable documents
DOCS += $(DOCS:$(OUTDIR)%=$(PRTDIR)%)

# APS keywords default file
ATSWORDS ?= $(ATSDIR)/keywords.gen

# main recipe
all: compile mrproper

compile: $(DOCS)

$(OUTDIR)/%pdf:$(SRC) $(DEPS)
	@TEXINPUTS=$(IMGDIR):$(@:$(OUTDIR)%.pdf=$(SRCDIR)%):$$TEXINPUTS \
		$(LATEX) -jobname=$(notdir $(@:%.pdf=%)) -output-directory=$(patsubst %/,%,$(dir $@)) \
		"\def\is$(notdir $(@:%.pdf=%)){1} \input{$<}" $(LATEX_OUT_CLEAN)
	@TEXINPUTS=$(IMGDIR):$(@:$(OUTDIR)%.pdf=$(SRCDIR)%):$$TEXINPUTS \
		$(LATEX) -jobname=$(notdir $(@:%.pdf=%)) -output-directory=$(patsubst %/,%,$(dir $@)) \
		"\def\is$(notdir $(@:%.pdf=%)){1} \input{$<}" $(LATEX_OUT_QUIET)
	@echo "ATS keywords matching test for $(notdir $@) (`pdftotext -q $@ - | grep -wio -f $(ATSWORDS) | sort -f | uniq -i | wc -l`/`wc -l $(ATSWORDS)`)"

$(PRTDIR)/%pdf:$(SRCDIR)/skeleton.tex $(DEPS)
	@TEXINPUTS=$(IMGDIR):$(@:$(PRTDIR)%.pdf=$(SRCDIR)%):$$TEXINPUTS \
		$(LATEX) -jobname=$(notdir $(@:%.pdf=%)) -output-directory=$(patsubst %/,%,$(dir $@)) \
		"\def\is$(notdir $(@:%.pdf=%)){1} \def\isprintable{1} \input{$<}" $(LATEX_OUT_QUIET)
	@TEXINPUTS=$(IMGDIR):$(@:$(PRTDIR)%.pdf=$(SRCDIR)%):$$TEXINPUTS \
		$(LATEX) -jobname=$(notdir $(@:%.pdf=%)) -output-directory=$(patsubst %/,%,$(dir $@)) \
		"\def\is$(notdir $(@:%.pdf=%)){1} \def\isprintable{1} \input{$<}" $(LATEX_OUT_QUIET)

mrproper:
	@rm -f {$(PRTDIR),$(OUTDIR)}/*.{out,log,aux}

clean:
	@echo 'cleaned'
	@rm -f $(DOCS)

.PHONY: all compile mrproper clean
