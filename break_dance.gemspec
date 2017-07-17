# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'break_dance/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.3'

  spec.name          = 'break_dance'
  spec.version       = BreakDance::VERSION
  spec.authors       = ['Zlatko Zahariev']
  spec.email         = ['zlatko.zahariev@gmail.com']
  spec.description   = %q{Rails authorization gem.}
  spec.summary       = %q{Rails authorization for data-centric applications based on ActiveRecord.}
  spec.homepage      = 'https://github.com/notentered/breakdance'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'request_store_rails'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
