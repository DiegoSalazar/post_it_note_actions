# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'post_it_note_actions/version'

Gem::Specification.new do |spec|
  spec.name          = "post_it_note_actions"
  spec.version       = PostItNoteActions::VERSION
  spec.authors       = ["Diego Salazar"]
  spec.email         = ["diego@greyrobot.com"]

  spec.summary       = %q{Generates an HTML page of Post It Notes listing all Rails controller actions.}
  spec.description   = %q{Make writing feature tests for a legacy Rails app a little more fun by generating Post It Notes of actions to test, grouped by average lines of code.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
