pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
evince $1.pdf &

## Cleanup
rm -f *~ 
rm -f *.aux
rm -f *.dvi
rm -f *.log
rm -f *.nav
rm -f *.out
rm -f *.snm
rm -f *.toc
rm -f *.bbl
rm -f *.blg
rm -f *.fls
rm -f *.fdb_latexmk

