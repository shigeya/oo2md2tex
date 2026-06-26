# Sample
RUBY=bundle exec ruby
OO2TEXT=../../bin/oo2text
MD2TEX=../../bin/md2tex

.SUFFIXES: .tex

.md.tex:; $(RUBY) ../../bin/md2tex $< > $@

sample.pdf: sample.tex
	latex sample
	dvipdfmx sample

sample.tex: sample.ooutline preamble.tex trailer.tex
	(cat preamble.tex ; ($(RUBY) $(OO2TEXT) sample.ooutline | $(RUBY) $(MD2TEX) ); cat trailer.tex) > sample.tex

clean::
	rm -f sample.log sample.aux sample.pdf sample.md sample-md.tex sample.dvi
