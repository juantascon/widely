MAINFILE := ./widely-presentation.tex

all:
	latex $(MAINFILE)
	latex $(MAINFILE)
	latex $(MAINFILE)
	pdflatex $(MAINFILE)

clean:
	@rm *.log *.lof *.toc *.nav *.snm *.out *.dvi *.aux *.pdf *.backup */*.backup */*.aux 2>/dev/null
