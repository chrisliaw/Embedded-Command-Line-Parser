
SPEC = Gem::Specification.new do |spec|
  spec.name = "Cmdline_Parser"
  spec.version = "0.1.1"
  spec.summary = "Another Ruby command line parser, intended to be embedded into application."
  
  spec.author = "Chris Liaw Man Cheon"
  spec.email = "omikron.tech@gmail.com"
  
  require 'rake'

  spec.files = ["changeset.txt","README.txt","cmdlineparser.rb","lib/cmdline_parser.rb","test/test_cmdline_parser.rb","test/test_cmdline.rb"]
#  files = FileList['*']
#  spec.files = files.delete_if do |f|
#    f.include?(".gem") || f.include?("gemspec")
#  end
  
  spec.extra_rdoc_files = ["README.txt"]
  
  spec.require_path = "."
  spec.autorequire = "cmdlineparser.rb"
  
end