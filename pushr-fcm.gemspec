$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'pushr-fcm/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'pushr-fcm'
  s.version     = PushrFcm::VERSION
  s.authors     = ['Tom Pesman']
  s.email       = ['tom@tnux.net']
  s.homepage    = 'https://github.com/9to5/pushr-fcm'
  s.summary     = 'FCM (Android) part of the modular push daemon.'
  s.description = 'FCM support for the modular push daemon.'
  s.licenses    = ['MIT']

  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.files         = `git ls-files lib`.split("\n") + ['README.md', 'MIT-LICENSE']
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.2.0'

  s.add_runtime_dependency 'multi_json'
  s.add_runtime_dependency 'pushr-core'
  s.add_runtime_dependency 'activemodel'
  s.add_runtime_dependency 'googleauth'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'mock_redis'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rubocop'
end
