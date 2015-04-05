
build:
	sed -i -e 's/\\begin{verbatim}/\\begin{minipage}\{0\.95\\textwidth}\\begin{lstlisting}/g' s_*.tex
	sed -i -e 's/\\end{verbatim}/\\end{lstlisting}\\end{minipage}/g' s_*.tex
	latex document.tex
	bibtex document
	latex document.tex
	pdflatex document.tex

check:
	@echo "The following items may contain weak word usage.--------------------"
	@sh ./weasels.sh s_*.tex 1>&2
	@echo "The following items may contain passive language.-------------------"
	@sh ./passive_voice.sh s_*.tex 1>&2
	@echo "The following items may contain unnecessary duplication.------------"
	@perl ./dups s_*.tex 2>&2
	@echo "Checking spelling.---------------------------------------------------"
	@aspell -c -t s_*.tex 
	@echo "Checking diction.---------------------------------------------------"
	@sh diction.sh s_*.tex 1>&2

style:
	@echo "Checking for nominalizations.---------------------------------------"
	@sh style.sh s_*.tex 1>&2

test:
	#$(MAKE) check
	$(MAKE) build
	./focus &> /dev/null

open:
	#open document.pdf
	zathura document.pdf &

clean:
	rm -f *.out *.aux *.dvi *.log *.blg *.bbl *.tex-e
