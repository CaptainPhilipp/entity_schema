
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'entity_schema/version'

Gem::Specification.new do |spec|
  spec.name          = 'entity_schema'
  spec.version       = EntitySchema::VERSION
  spec.authors       = ['Captain Philipp']
  spec.email         = ['ph-s@mail.ru']

  spec.summary       = 'DSL for describe Entities'
  spec.description   = 'Simple DSL for describe schema of mapping Hash to entity Object ' \
                       'and vice-versa'
  spec.homepage      = 'https://github.com/CaptainPhilipp/entity_schema'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.required_ruby_version = '>= 2.5.0' # TODO: find minimal valid version
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'simplecov'

  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rspec'
end
