# Minimal makefile for LaTeX documents
DOCS := cv resume

all: compile clean

compile: $(DOCS:%=%.pdf)

%pdf:%tex
	pdflatex $<
	pdflatex $<

clean:
	rm -f *.{out,log,aux}
