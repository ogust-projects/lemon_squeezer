# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lemon_squeezer/version'

Gem::Specification.new do |spec|
  spec.name          = "lemon_squeezer"
  spec.version       = LemonSqueezer::VERSION
  spec.authors       = ["Benjamin Guimberteau"]
  spec.email         = ["benjamin@bhacklab.fr"]

  spec.summary       = "Ruby gem for Lemonway payment solution"
  spec.description   = "Use this library for use Lemonway easily with ruby"
  spec.homepage      = "https://github.com/e-lam/lemon_squeezer"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "savon", "~> 2.10.0"
  spec.add_dependency "ibanizator"
end
