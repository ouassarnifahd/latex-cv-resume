# Minimal makefile for LaTeX documents
DEPS := faresume.cls style.tex
DOCS := cv resume

all: compile mrproper

compile: $(DOCS:%=%.pdf)

%pdf:%tex $(DEPS)
	pdflatex $<
	pdflatex $<

mrproper:
	rm -f *.{out,log,aux}

clean:
	rm -f *.pdf

.PHONY: all compile mrproper clean
