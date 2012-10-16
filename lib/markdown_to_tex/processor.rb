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

require 'date'

module MarkdownToTeX

  class Processor
  
    attr_reader :git_branch_name, :git_wd_hash, :git_hash_wd_long,
                :git_commit_line, :git_status, :git_status_long,
                :git_describe,
                :run_stamp

    def initialize(options)
      @options = options
      @run_stamp = DateTime.now.to_s
      if @options[:git]
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
			else
			  @macros = { }
			end
    end

    def process(text)
      @renderer = Redcarpet::Markdown.new(MarkdownToTeX::Renderer)
      TextProcessor.process_final(@renderer.render(text), @macros)
    end
    
    def job_signature; <<-EOS.gsub(/^\s+%/, '%')
      % oo-tex.rb run at #{@run_stamp}
      % description: #{@git_describe}
      % revision: #{@git_wd_hash_long}
      % commit log:
      % #{@git_commit_line}
      EOS
    end

  end

end
