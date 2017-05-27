# Sample
OO2TEXT=../../bin/oo2text
MD2TEX=../../bin/md2tex

.SUFFIXES: .tex

.md.tex:; ruby ../../bin/md2tex $< > $@

sample.pdf: sample.tex
	latex sample
	dvipdfmx sample

sample.tex: sample.ooutline preamble.tex trailer.tex
	(cat preamble.tex ; (ruby $(OO2TEXT) sample.ooutline | ruby $(MD2TEX) ); cat trailer.tex) > sample.tex

clean::
	rm -f sample.log sample.aux sample.pdf sample.md sample-md.tex sample.dvi
