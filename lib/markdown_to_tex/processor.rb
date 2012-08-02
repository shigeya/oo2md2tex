require 'date'

module MarkdownToTeX

  class Processor
  
    attr_reader :git_branch_name, :git_wd_hash, :git_hash_wd_long,
                :git_commit_line, :git_status, :git_status_long,
                :git_describe,
                :run_stamp

    def initialize
      @run_stamp = DateTime.now.to_s

      IO.popen("git branch -v --no-abbrev").each do |l|
        if l =~ /(\*|.)\s+(\S+)\s+([0-9a-f]+)\s(.*)/
          if $1 == "*"
            @git_branch_name = $2
            @git_wd_hash_long = $3
            @git_wd_hash = @git_wd_hash_long[0,6]
            @git_commit_line = $4
            @git_commit_line.gsub!(/\#/, '\#')
            @git_commit_line.gsub!(/\%/, '\%')
            @git_commit_line.gsub!(/\[ahead.*\] /, '')
            @git_status = @git_wd_hash + ": " + @git_commit_line
            @git_status_long = @git_commit_line + '\\\\\\\\' + @git_wd_hash_long + '\\\\\\\\' + @git_branch_name
          end
        end
      end
      

      @git_describe = "(no names found for git describe)"
      
      IO.popen("git describe --dirty --long").each do |l|
        if l =~ /(.*)/
          @git_describe = $1
        end
      end

      @macros = {
        "__OO2_RUN_STAMP__" => @run_stamp,
        "__OO2_GIT_DESCRIBE__" => @git_describe,
        "__OO2_GIT_STATUS__" => @git_status,
        "__OO2_GIT_STATUS_LONG__" => @git_status_long,
        "__OO2_GIT_HASH_LONG__" => @git_wd_hash_long
      }
    end

  
    def process(text)
      @renderer = Redcarpet::Markdown.new(MarkdownToTeX::Renderer)
      TextProcessor.process_final(@renderer.render(text), @macros)
    end
    
  end

end