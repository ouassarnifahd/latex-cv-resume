# Minimal makefile for LaTeX documents
DOCS := cv resume

all: compile mrproper

compile: $(DOCS:%=%.pdf)

%pdf:%tex
	pdflatex $<
	pdflatex $<

mrproper:
	rm -f *.{out,log,aux}

clean:
	rm -f *.pdf
