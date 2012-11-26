Gem::Specification.new do |s|
  s.name        = 'oo2md2tex'
  s.version     = '0.0.4'
  s.date        = '2012-11-26'
  s.summary     = "oo2text and md2tex"
  s.description = "A barebone Markdown to TeX/LaTeX converter kit via OmniOutliner"
  s.authors     = ["Shigeya Suzuki"]
  s.email       = 'shigeya@wide.ad.jp'
  s.files       = %w[lib/markdown_to_tex/processor.rb
                     lib/markdown_to_tex/renderer.rb
                     lib/markdown_to_tex/text_processor.rb
                     lib/markdown_to_tex.rb
                     bin/oo2text
                     bin/md2tex
                     bin/ja-ten-maru-normalize]
  s.homepage    = 'http://github.com/shigeya/oo2md2tex'
  s.require_paths = %w[lib]
  s.executables = ["oo2text","md2tex","ja-ten-maru-normalize"]
  s.extra_rdoc_files = %w[Format.md]
  s.license = 'ISC'
  s.required_ruby_version = '>= 1.9'
  s.add_runtime_dependency 'redcarpet', '~> 2.1'
  s.add_runtime_dependency 'nokogiri', '~> 1.5'
  
end
