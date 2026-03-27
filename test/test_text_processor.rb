# frozen_string_literal: true

require "minitest/autorun"
require "redcarpet"
require_relative "../lib/markdown_to_tex"

class TestTextProcessor < Minitest::Test
  TP = MarkdownToTeX::TextProcessor

  # reference

  def test_reference_single_citation
    assert_equal '\\CITE{foo}', TP.reference("[foo]")
  end

  def test_reference_multiple_citations
    assert_equal '\\CITE{foo,bar}', TP.reference("[foo, bar]")
  end

  def test_reference_this_sec
    assert_equal '\\thissecKEY{}', TP.reference("[this:sec]")
  end

  def test_reference_prev_chap
    assert_equal '\\prevchapKEY{}', TP.reference("[prev:chap]")
  end

  def test_reference_next_fig
    assert_equal '\\nextfigKEY{}', TP.reference("[next:fig]")
  end

  def test_reference_sec_label
    assert_equal '\\secREF{sec:intro}', TP.reference("[sec:intro]")
  end

  def test_reference_fig_label
    assert_equal '\\figREF{fig:diagram}', TP.reference("[fig:diagram]")
  end

  def test_reference_table_label
    assert_equal '\\tableREF{table:results}', TP.reference("[table:results]")
  end

  def test_reference_quoted_text
    assert_equal '[hello world]', TP.reference('["hello world"]')
  end

  def test_reference_plain_text_unchanged
    assert_equal "no references here", TP.reference("no references here")
  end

  # label_split

  def test_label_split_with_label
    text, label = TP.label_split("Introduction [intro]")
    assert_equal "Introduction", text.strip
    assert_equal "intro", label
  end

  def test_label_split_without_label
    text, label = TP.label_split("Introduction")
    assert_equal "Introduction", text
    assert_equal "", label
  end

  def test_label_split_with_namespace_label
    text, label = TP.label_split("Figures [sec:figures]")
    assert_equal "Figures", text.strip
    assert_equal "sec:figures", label
  end

  # short_desc

  def test_short_desc_with_short_title
    name, short = TP.short_desc("Short Title | Long Title")
    assert_equal "Long Title", name.strip
    assert_equal "[Short Title ]", short
  end

  def test_short_desc_without_short_title
    name, short = TP.short_desc("Just a Title")
    assert_equal "Just a Title", name
    assert_equal "", short
  end

  # process_header

  # level_tag mapping: 0→chapter, 1→section, 2→subsection, 3→subsubsection
  # Redcarpet passes h1=1, h2=2, etc. so h1→section, h2→subsection, h3→subsubsection

  def test_process_header_level0_chapter
    result = TP.process_header("Introduction", 0)
    assert_includes result, "\\chapter{Introduction}"
  end

  def test_process_header_level1_section
    result = TP.process_header("Introduction", 1)
    assert_includes result, "\\section{Introduction}"
  end

  def test_process_header_level2_subsection
    result = TP.process_header("Background", 2)
    assert_includes result, "\\subsection{Background}"
  end

  def test_process_header_level3_subsubsection
    result = TP.process_header("Details", 3)
    assert_includes result, "\\subsubsection{Details}"
  end

  def test_process_header_with_label
    result = TP.process_header("Introduction [intro]", 1)
    assert_includes result, "\\section{Introduction}"
    assert_includes result, "\\label{intro}"
  end

  def test_process_header_with_short_title
    result = TP.process_header("Short | Long Title", 2)
    assert_includes result, "[Short ]"
    assert_includes result, "{Long Title}"
  end

  def test_process_header_comment_line
    result = TP.process_header("Test", 1)
    assert_match(/^%+ SECTION: Test\n/, result)
  end

  # process_paragraph

  def test_process_paragraph_plain
    result = TP.process_paragraph("Hello world")
    assert_equal "Hello world", result
  end

  def test_process_paragraph_description_format
    result = TP.process_paragraph("((item text))")
    assert_equal '\\ITEM{item text}', result
  end

  def test_process_paragraph_with_citation
    result = TP.process_paragraph("See [foo] for details")
    assert_equal 'See \\CITE{foo} for details', result
  end

  # comment_line

  def test_comment_line_padding
    result = TP.comment_line("TEST")
    assert_match(/^%+ TEST\n$/, result)
    # 78 - 1 - 4 = 73 percent signs, then space, then TEST, then newline
    assert_equal 73, result.count("%")
  end

  def test_comment_line_long_text
    long = "A" * 100
    result = TP.comment_line(long)
    # px = 78 - 1 - 100 = -23 → clamped to 1
    assert_equal 1, result.count("%")
  end

  # process_final

  def test_process_final_macro_expansion
    text = "stamp: __OO2_RUN_STAMP__"
    macros = { "__OO2_RUN_STAMP__" => "2024-01-01" }
    result = TP.process_final(text, macros)
    assert_equal "stamp: 2024-01-01", result
  end

  def test_process_final_multiple_macros
    text = "__A__ and __B__"
    macros = { "__A__" => "1", "__B__" => "2" }
    result = TP.process_final(text, macros)
    assert_equal "1 and 2", result
  end

  def test_process_final_no_macros
    text = "no macros here"
    result = TP.process_final(text, {})
    assert_equal "no macros here", result
  end
end
