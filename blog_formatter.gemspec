$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blog_formatter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blog_formatter"
  s.version     = BlogFormatter::VERSION
  s.authors     = 'Joshua Wehner'
  s.email       = 'joshua.wehner@gmail.com'
  s.homepage    = "http://www.joshuawehner.com/"
  s.summary     = "A simple formatting mechanism"
  s.description = "It's a really simple formatting mechanism"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.9"

  s.add_development_dependency "sqlite3"
end
