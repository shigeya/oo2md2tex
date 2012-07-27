module MarkdownToTeX
  class Renderer < Redcarpet::Render::Base
    HEADER_TYPE = {
      1 => "section",
      2 => "subection",
      3 => "subsubsection"
    }
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
      "\n\n\\#{HEADER_TYPE[header_level]}{#{text}}\n"
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
      text+"\n"
    end
    
    ## table(header, body)
    ## table_row(content)
    ## table_cell(content, alignment)
    
    # Span-level calls
    # A return value of `nil` will not output any data
    # If the method for a document element is not implemented,
    # the contents of the span will be copied verbatim
    ## autolink(link, link_type)
    ## codespan(code)
    def codespan(code)
      "\\verb+#{code}+"
    end
    ## double_emphasis(text)
    ## emphasis(text)
    ## image(link, title, alt_text)
    def linebreak()
      "\n%\n"
    end

    ## link(link, title, content)

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
