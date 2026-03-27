# frozen_string_literal: true

require "minitest/autorun"
require "redcarpet"
require_relative "../lib/markdown_to_tex"

class TestProcessor < Minitest::Test
  def test_process_without_git
    processor = MarkdownToTeX::Processor.new(git: false)
    result = processor.process("Hello world\n")
    assert_includes result, "Hello world"
    assert_includes result, "% start-of-output"
    assert_includes result, "% end-of-output"
  end

  def test_process_header_conversion
    processor = MarkdownToTeX::Processor.new(git: false)
    result = processor.process("# My Section\n")
    assert_includes result, "\\section{My Section}"
  end

  def test_process_macro_expansion
    processor = MarkdownToTeX::Processor.new(git: false)
    result = processor.process("Hello\n")
    # Without git, no macros to expand, but process should not error
    assert_kind_of String, result
  end

  def test_job_signature_without_git
    processor = MarkdownToTeX::Processor.new(git: false)
    sig = processor.job_signature
    assert_match(/^% md2tex run at /, sig)
    refute_includes sig, "% revision:"
    refute_includes sig, "% commit log:"
  end

  def test_job_signature_with_git
    processor = MarkdownToTeX::Processor.new(git: true)
    sig = processor.job_signature
    assert_match(/^% md2tex run at /, sig)
    assert_includes sig, "% description:"
    assert_includes sig, "% revision:"
  end

  def test_process_citation_in_paragraph
    processor = MarkdownToTeX::Processor.new(git: false)
    result = processor.process("See [foo] for details.\n")
    assert_includes result, '\\CITE{foo}'
  end

  def test_process_multiple_elements
    input = <<~MD
      # Introduction

      This is a paragraph.

      ## Background

      Another paragraph with [cite1].
    MD
    processor = MarkdownToTeX::Processor.new(git: false)
    result = processor.process(input)
    assert_includes result, "\\section{Introduction}"
    assert_includes result, "\\subsection{Background}"
    assert_includes result, '\\CITE{cite1}'
    assert_includes result, "This is a paragraph."
  end
end
