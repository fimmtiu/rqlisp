
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rqlisp/version"

Gem::Specification.new do |spec|
  spec.name          = "rqlisp"
  spec.version       = Rqlisp::VERSION
  spec.authors       = ["Dennis Taylor"]
  spec.email         = ["dennis.taylor@clio.com"]

  spec.summary       = %q{A little Lisp interpreter written in a day and a half.}
  spec.homepage      = "https://github.com/fimmtiu/rqlisp"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "parslet"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug"
end
