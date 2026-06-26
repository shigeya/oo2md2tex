# frozen_string_literal: true

require "minitest/autorun"
require "open3"

# Integration tests for the bin/oo2text script.
#
# The script parses an OmniOutliner package and prints extended Markdown to
# stdout. These tests run it as a subprocess against the v5 and v6 sample
# fixtures and assert on the full output, guarding the rank-ordering fix
# (empty rank="" siblings must keep document order instead of colliding).
class TestOo2text < Minitest::Test
  BIN = File.expand_path("../bin/oo2text", __dir__)
  SAMPLE_DIR = File.expand_path("../sample", __dir__)

  EXPECTED = <<~TEXT
    # sample 1
    This is a sample body
    # sample 2
    This is another sample body
    # sample 3
    This is yet another sample body
    and it's child
    # sample 4
    This is hyperlink for github.com
  TEXT

  def run_oo2text(sample)
    file = File.join(SAMPLE_DIR, sample, "sample.ooutline")
    skip "missing fixture #{file}" unless File.exist?(file)
    stdout, stderr, status = Open3.capture3("ruby", BIN, file)
    assert status.success?, "oo2text failed: #{stderr}"
    stdout
  end

  def test_v5_sample_output
    assert_equal EXPECTED, run_oo2text("v5")
  end

  def test_v6_sample_output
    assert_equal EXPECTED, run_oo2text("v6")
  end

  # v6 differs from v5 only by added previews/*.jpeg and checkbox/entry
  # elements; the extracted text must be identical.
  def test_v5_and_v6_produce_identical_output
    assert_equal run_oo2text("v5"), run_oo2text("v6")
  end
end
