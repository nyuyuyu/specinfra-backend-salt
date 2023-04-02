# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'specinfra/salt_backend/version'

Gem::Specification.new do |spec|
  spec.name        = 'specinfra-backend-salt'
  spec.version     = Specinfra::SaltBackend::VERSION
  spec.licenses    = ['MIT']
  spec.summary     = 'Specinfra backend for SaltStack'
  spec.description = 'Specinfra backend for SaltStack'
  spec.authors     = ['nyuyuyu']
  spec.email       = ['127820811+nyuyuyu@users.noreply.github.com']
  spec.homepage    = 'https://github.com/nyuyuyu/specinfra-backend-salt'
  spec.files       = `git ls-files -z ./lib/*`.split("\x0")
  spec.files      += %w[README.md LICENSE CODE_OF_CONDUCT.md]

  spec.add_runtime_dependency 'specinfra', '~> 2.0'

  spec.add_development_dependency 'bundler', '>= 1.13'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
