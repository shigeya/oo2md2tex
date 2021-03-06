#
#    Copyright (c)2012 Shigeya Suzuki
#
#    Permission to use, copy, modify, and/or distribute this software for any
#    purpose with or without fee is hereby granted, provided that the above
#    copyright notice and this permission notice appear in all copies.
#
#    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

module MarkdownToTeX
  class Renderer < Redcarpet::Render::Base
    # Block-level calls
    # If the return value of the method is `nil`, the block
    # will be skipped.
    # If the method for a document element is not implemented,
    # the block will be skipped.
    # 
    # Example:
    #
    #   class RenderWithoutCode < Redcarpet::Render::HTML
    #     def block_code(code, language)
    #       nil
    #     end
    #   end
    #
    def block_code(code, language)
      wrap_environment("verbatim", code)
    end
    
    ## block_quote(quote)
    ## block_html(raw_html)
    def header(text, header_level)
      TextProcessor.process_header(text, header_level)
    end
    
    ## hrule()

    def list(contents, list_type)
      environment = case list_type
                      when "ordered" then "enumerated"
                      when "unordered" then "itemize"
                      end
      wrap_environment("itemize", contents)
    end

    def list_item(text, list_type)
      "\\item #{text}\n"
    end

    def paragraph(text)
      TextProcessor.process_paragraph(text)+"\n\n"
    end
    
    ## table(header, body)
    ## table_row(content)
    ## table_cell(content, alignment)
    
    # Span-level calls
    # A return value of `nil` will not output any data
    # If the method for a document element is not implemented,
    # the contents of the span will be copied verbatim
    def autolink(link, link_type)
      "{{autolink:<#{link}>, title:<#{title}>, content:<#{content}>}}"
    end

    def codespan(code)
      qchar = if code =~ /\+/ then "!" else "+" end
      "\\verb#{qchar}#{code}#{qchar}"
    end
    ## double_emphasis(text)
    ## emphasis(text)
    ## image(link, title, alt_text)
    def linebreak()
      "\n%\n"
    end

    def link(link, title, content)
      "#{content}\\nobreak\\footnote{\\url{#{link}}}"
    end

    def raw_html(raw_html)
      raw_html
    end
    
    ## triple_emphasis(text)
    ## strikethrough(text)
    ## superscript(text)
    
    # Low level rendering
    ## entity(text)
    ## normal_text(text)
    
    # Header of the document
    # Rendered before any another elements
    def doc_header()
      "% start-of-output\n"
    end
    
    # Footer of the document
    # Rendered after all the other elements
    def doc_footer()
      "\n% end-of-output"
    end
    
    # Pre/post-process
    # Special callback: preprocess or postprocess the whole
    # document before or after the rendering process begins
    ## preprocess(full_document)
    ## postprocess(full_document)
    
    
  private
    def wrap_environment(environment, text)
      "\\begin{#{environment}}\n"+
      text +
      "\\end{#{environment}}\n"
    end

  end
end
