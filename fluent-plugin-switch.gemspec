# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-switch"
  gem.version       = "0.0.4"
  gem.date          = '2017-08-08'
  gem.authors       = ["Arash Vatanpoor"]
  gem.email         = ["arash@a-venture.org"]
  gem.summary       = %q{Fluentd filter plugin to categorzie events.}
  gem.description   = %q{Fluentd filter plugin to categozie events, similar to switch statement in PLs}
  gem.homepage      = 'https://github.com/a-venture/fluent-plugin-switch'
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]
  gem.required_ruby_version = ">= 2.1.2"
  # dependency
  gem.add_runtime_dependency "fluentd", '~> 0.12'
end
