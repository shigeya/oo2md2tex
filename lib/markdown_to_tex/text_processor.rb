module MarkdownToTeX
  class TextProcessor

    @@tag_namespace = nil
    @@cite_map = {}
    @@level_tag =  ["chapter", "section", "subsection", "subsubsection"]
    @@level_shift = 0

    # Process a paragraph
    def self.process_paragraph(text)
      self.reference(text)
    end

    # Citation Handling

    def self.bib_name_map(n)
      @@cite_map.has_key?(n) ? @@cite_map[n] : n
    end

    def self.tag_name_map(n)
      return "" if n == nil
      if @@tag_namespace == nil or n =~ /#{@@tag_namespace}:/
        return n
      end
      @@tag_namespace + ":" + n
    end

    def self.label_name_map(n)
      if @@tag_namespace == nil
        return bib_name_map(n)
      end

      if n =~ /(chap|part|sec|subsec|subsubsec|fig|table|eq):(.+)/
        r = $1 + ":" + self.tag_name_map($2)
      else
        r = self.bib_name_map(n)
      end
      r
    end

    def self.ref_name_map(n)
      self.label_name_map(n)
    end

    def self.ref_name_map_cite(k)
      cite = "CITE"
      text = k.split(/\s*,\s*/).each.map {|kk| self.ref_name_map(kk)}.join(",")
      if text =~ /"(.*)"/
        r = "[#{$1}]"
      else
        r = "\\#{cite}{#{text}}"
      end
      r
    end

    def self.reference(text)
      text.gsub(/\[([^\]]+)\]/) { self.ref_name_map_cite($1);}.
           gsub(/\[(this|prev|next):(chap|part|sec|subsec|subsubsec|fig|table)\]/) { "\\#{$1}#{$2}KEY{}" }.
           gsub(/\[((chap|part|sec|subsec|subsubsec|fig|table):[^\]]+)\]/) { "\\#{$2}REF{#{self.ref_name_map($1)}}" }
    end

    def self.label_split(s)
      label = ""
      if s.sub!(/\s*\[([^\]]+)\]/, '')
        label = $1
      end
      [s, label]
    end

    def self.short_desc(s)  # map short|long
      s_short = ""
      if s =~ /\s*([^\|]+)\s*\|\s*(.+)\s*/
       s_short = "[#{$1}]"
        s = $2
      end
      [s, s_short]
    end

    def self.level_tag(d)
      @@level_tag[d + @@level_shift]
    end

    # Process a header
    def self.process_header(text, level)
      name, label = self.label_split(text)
      name, name_short = self.short_desc(name)
      tag = self.level_tag(level)
      the_label = self.label_name_map(label)
      star = "" # star ? "*" : ""
      s = self.comment_line(tag.upcase + ": #{name}")
      s << "\\#{tag}#{star}#{name_short}{#{name}}"
      s << "\\label{#{the_label}}" unless label.empty?
      s << "\n"
      s
    end


    # Process on whole output text

    def self.process_final(text, macros)
      # Macro expansions
      macros.each {|m, v| text.gsub!(m, v) }
      text
    end

    def self.comment_line(s)
      px = (78 - 1 - s.length)
      px = 1 if px < 1
      "%" * px + " " + s + "\n"
    end

  end
end