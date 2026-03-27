# frozen_string_literal: true

require "minitest/autorun"
require "redcarpet"
require_relative "../lib/markdown_to_tex"

class TestRenderer < Minitest::Test
  def setup
    @md = Redcarpet::Markdown.new(MarkdownToTeX::Renderer)
  end

  def render(markdown)
    @md.render(markdown)
  end

  # block_code

  def test_block_code
    result = render("    code here\n")
    assert_includes result, "\\begin{verbatim}"
    assert_includes result, "code here"
    assert_includes result, "\\end{verbatim}"
  end

  # header

  def test_header_h1
    result = render("# Section Title\n")
    assert_includes result, "\\section{Section Title}"
  end

  def test_header_h2
    result = render("## Subsection Title\n")
    assert_includes result, "\\subsection{Subsection Title}"
  end

  # list

  def test_unordered_list
    result = render("- item one\n- item two\n")
    assert_includes result, "\\begin{itemize}"
    assert_includes result, "\\item item one"
    assert_includes result, "\\item item two"
    assert_includes result, "\\end{itemize}"
  end

  # paragraph

  def test_paragraph
    result = render("Hello world\n")
    assert_includes result, "Hello world"
  end

  def test_paragraph_with_description
    result = render("((my item))\n")
    assert_includes result, '\\ITEM{my item}'
  end

  # codespan

  def test_codespan
    result = render("use `foo` here\n")
    assert_includes result, "\\verb+foo+"
  end

  def test_codespan_with_plus
    result = render("use `a+b` here\n")
    assert_includes result, "\\verb!a+b!"
  end

  # link

  def test_link
    result = render("[text](http://example.com)\n")
    assert_includes result, "text"
    assert_includes result, "\\nobreak\\footnote{\\url{http://example.com}}"
  end

  # doc_header and doc_footer

  def test_doc_structure
    result = render("test\n")
    assert_match(/^% start-of-output/, result)
    assert_match(/% end-of-output$/, result)
  end

  # raw_html pass-through

  def test_raw_html
    result = render("<div>raw</div>\n")
    assert_includes result, "<div>raw</div>"
  end
end
