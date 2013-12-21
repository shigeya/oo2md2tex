# Sample

.SUFFIXES: .md .tex

.md.tex:; ruby ../bin/md2tex $< > $@

sample.pdf: sample.tex
	latex sample
	dvipdfmx sample

sample-md.tex: sample-md.md

sample.tex: sample-md.tex preamble.tex trailer.tex
	(cat preamble.tex sample-md.tex trailer.tex) > sample.tex

sample-md.md: sample.oo3/contents.xml
	ruby ../bin/oo2text sample.oo3 > sample-md.md

clean::
	rm -f sample.log sample.aux sample.pdf sample-md.md sample-md.tex sample.dvi
