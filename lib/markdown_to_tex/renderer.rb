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
    ## block_code(code, language)
    ## block_quote(quote)
    ## block_html(raw_html)
    ## header(text, header_level)
    ## hrule()
    ## list(contents, list_type)
    ## list_item(text, list_type)
    ## paragraph(text)
    ## table(header, body)
    ## table_row(content)
    ## table_cell(content, alignment)
    
    # Span-level calls
    # A return value of `nil` will not output any data
    # If the method for a document element is not implemented,
    # the contents of the span will be copied verbatim
    ## autolink(link, link_type)
    ## codespan(code)
    ## double_emphasis(text)
    ## emphasis(text)
    ## image(link, title, alt_text)
    ## linebreak()
    ## link(link, title, content)
    ## raw_html(raw_html)
    ## triple_emphasis(text)
    ## strikethrough(text)
    ## superscript(text)
    
    # Low level rendering
    ## entity(text)
    ## normal_text(text)
    
    # Header of the document
    # Rendered before any another elements
    def doc_header()
      "start"
    end
    
    # Footer of the document
    # Rendered after all the other elements
    def doc_footer()
      "end"
    end
    
    # Pre/post-process
    # Special callback: preprocess or postprocess the whole
    # document before or after the rendering process begins
    ## preprocess(full_document)
    ## postprocess(full_document)

  end
end
