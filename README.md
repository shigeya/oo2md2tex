# oo2text and text2tex - A barebone Markdown to TeX/LaTeX converter kit via OmniOutliner

(including OmniOutliner v3 file to text script)

# Purpose/Motivation

When creating structured document, I want to use outline processor. For the output, I want to use `TeX` for best result. This usually achieved by some integrated
environment like [Scrivener][Scrivener].

[Scrivener]: http://www.literatureandlatte.com/scrivener.php

For writing a simple text, OmniOutliner is very well. There is no simple way to convert the document file into `TeX`, and also cumbersome to save, convert to `TeX`, convert to `PDF`, and preview.

To achieve this, I implemented a script `oo2tex`. It was developed and used it for several years. I also used it to write my Ph.D. dissertation (180 pages -- the use of outline processor helped a lot to achieve this.)

While I'm reviewing how I can improve the `oo2tex`, I realized it is too complex and not easy to maintain. So I created simpler version which achieve similar result. So these scripts.


# Scripts

Using following two scripts convert Markdown formatted (outlined) OmniOutliner file into `TeX` file.

[watchr]:  https://github.com/mynyml/watchr

- `md2tex` convert slightly extended Markdown text file into TeX.
  The extension described in `Format.md`

- `oo2text` extract [OmniOutliner][oo] v3 file as text file

[oo]: http://www.omnigroup.com/omnioutliner

- `ja-ten-maru-normalize` is a utility script to normalize Japanse multibyte comma and periods.


# Requirements

Ruby 1.9 and gems:

- [Redcarpet](https://github.com/vmg/redcarpet/)

- nokogiri and zlib for OmniOutliner file handling

# Typical usage

Extract text contents of `*.oo3` into a file as Markdown text using `oo2text`, then convert the Markdown file into `TeX` file using `md2tex`. Use the output
as body of `TeX` text

From `Makefile` in `sample` directory:

    # Sample Makefile
    .SUFFIXES: .md .tex
    
    .md.tex:; ../bin/md2tex $< > $@
    
    sample.pdf: sample.tex
            latex sample
            dvipdfmx sample
    
    sample-md.tex: sample-md.md
    
    sample.tex: sample-md.tex preamble.tex trailer.tex
            (cat preamble.tex sample-md.tex trailer.tex) > sample.tex

    sample-md.md: sample.oo3/contents.xml
            ../bin/oo2text sample.oo3 > sample-md.md
    
    clean::
            rm -f sample.log sample.aux sample.pdf sample-md.md sample-md.tex sample.dvi

You can automate whole PDF generation process on save of OmniOutliner, 
by using [watchr][watchr] script like the one in `tools` directory.

# Macro substitutions

To embed some of build time information onto the file, following macros are defined to use:

- `_OO2_RUN_STAMP__`

  Simple timestamp by `date`
  
- `__OO2_GIT_DESCRIBE__`

  Output of `git describe`. If no meaningful tags are defined, git will emit error.

- `__OO2_GIT_STATUS__`

  Output of tweaked `git status`

- `__OO2_GIT_STATUS_LONG__`

  Output of tweaked `git status` in long format with full-length hash of last commit

- `__OO2_GIT_HASH_LONG__`

  Value of full-length hash for last commit

# License

    Copyright (c)2012 Shigeya Suzuki

    Permission to use, copy, modify, and/or distribute this software for any
    purpose with or without fee is hereby granted, provided that the above
    copyright notice and this permission notice appear in all copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
