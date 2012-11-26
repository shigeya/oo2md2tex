# Modified Markdown format for md2tex

This document describes modified markdown format for md2tex.

# Interpretation of Markdown to TeX

md2tex's format a minor extension to John Gruber's [Markdown][markdown] format.

[markdown]: http://daringfireball.net/projects/markdown/

To avoid possible incompatibilities, tried to minimize the extension.
Followings are the extensions implemented in md2tex.

Basically, `md2tex`  can output either TeX or LaTeX text.


## Section name interpretation

Markdown's section titles are mapped directly into LaTeX's counterpart.

If a section name may include `[label]` at the end of title for the label
for the given section name. The output will be `\label{LABEL}` appended to the
section name.

LaTeX section command accepts optional _shorter_ title use for the
table-of-contents. you can specify this by using vertical bar like
this:

    # longer_title | shorter_title [LABEL]


## Comments

Characters after `%` treated as comments and no interpretations performed,
write to output as-is.


## LaTeX environments' items

Lines prefixed with number, dot and space like `1. ` is treated as a enumerated list item.

Lines prefixed with dash and space like `- ` is treated as a itemized list. Each of them are translated into `\item ` LaTeX commands.

Lines start with a text surrounded by double parenthesis like `((TEXT))` is a items with text. This text is translated into `\item[TEXT]` command.

## Labels/Citations

References are denoted by `[citation-key]`.
Multiple citations are allowed inside a bracket like this: `[cite_a, cite_b, cite_c]`.

Note that, writing citation with `[cite_a][cite_b]` is confusing to use with regard to Markdown syntax. Either separating these two with `[cite_a]\relax[\cite_b]` or such trick may be possible.

## Backslash handling caution

Markdown provides backslash escapes for the special characters. Backslash with
following letter passed as is. Thus, if you want to use special characters, 
you need to use backslash to escape. Note that if you want to use backslash itself,
you need to escape it by backslash too, so, if you want to put a line break
with two backslashes, you need four backslashes. Plan to have some automatic
escape when converting OmniOutliner file into Markdown, but is not available for now.


### Label format

Labels references are denoted by `[label-name]`. For labels inside the document
(non-citations) need to have prefixes.

- `sec:`
- `subsec:`
- `subsubsec:`
- `fig:` or `figure:`
- `tab:` or `table:`

### Special references

- `[this:sec]`
- `[this:subsec]`
- `[this:subsubsec]`
- `[prev:sec]` or `[previous:sec]`
- `[prev:subsec]` or `[prev:subsec]`
- `[prev:subsubsec]` or `[previous:subsubsec]`

