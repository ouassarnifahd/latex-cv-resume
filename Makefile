# Minimal makefile for LaTeX documents
OUT_ERROR := | grep -E --color=never '^! |^Output '
OUT_QUIET := 2&> /dev/null
OUT_CLEAN ?= $(OUT_ERROR)

DEPS := faresume.cls style.tex
DOCS := cv resume

all: compile mrproper

compile: $(DOCS:%=%.pdf)

%pdf:%tex $(DEPS)
	@pdflatex $< $(OUT_CLEAN)
	@pdflatex $< $(OUT_QUIET)
	
mrproper:
	@rm -f *.{out,log,aux}

clean:
	@echo 'cleaned'
	@rm -f *.pdf

.PHONY: all compile mrproper clean
