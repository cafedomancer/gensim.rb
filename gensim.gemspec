# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gensim/version'

Gem::Specification.new do |spec|
  spec.name          = "gensim"
  spec.version       = Gensim::VERSION
  spec.authors       = ["Shohei Umemoto"]
  spec.email         = ["cafedomancer@gmail.com"]

  spec.summary       = %q{A Ruby wrapper for gensim.}
  spec.description   = %q{A Ruby wrapper for gensim.}
  spec.homepage      = "https://github.com/cafedomancer/gensim.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pycall", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
