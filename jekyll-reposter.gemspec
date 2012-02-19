# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)


Gem::Specification.new do |s|
  s.name        = "jekyll-reposter"
  s.version     = "0.1.4"
  s.authors     = ["Stefan Wienert"]
  s.email       = ["stefan.wienert@pludoni.de"]
  s.homepage    = "https://github.com/zealot128/jekyll-reposter"
  s.summary     = %q{Reposting external feeds with jekyll}
  s.description = %q{Provides a interface for generating posts as a repost from external feeds. Tested with octopress.}

  s.rubyforge_project = "jekyll-reposter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "feedzirra"
  s.add_runtime_dependency "curb", "~> 0.8"
  s.add_runtime_dependency "stringex"
  s.add_runtime_dependency "sanitize"
end
