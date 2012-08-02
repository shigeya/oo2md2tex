module MarkdownToTeX
  class TextProcessor

    # Process a paragraph
    def self.process_paragraph(text)
      text
    end



    # Process on whole output text

    def self.process_final(text, macros)
      # Macro expansions
      macros.each {|m, v| text.gsub!(m, v) }
      text
    end

  end
end