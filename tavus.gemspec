# frozen_string_literal: true

require_relative "lib/tavus/version"

Gem::Specification.new do |spec|
  spec.name = "tavus"
  spec.version = Tavus::VERSION
  spec.authors = ["Vitor Oliveira"]
  spec.email = ["vbrazo@gmail.com"]

  spec.summary = "Ruby client for the Tavus API"
  spec.description = "A Ruby gem for interacting with the Tavus Conversational Video Interface API, supporting conversations and personas management."
  spec.homepage = "https://github.com/vbrazo/tavus"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/vbrazo/tavus"
  spec.metadata["changelog_uri"] = "https://github.com/vbrazo/tavus/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Runtime dependencies
  spec.add_dependency "json", "~> 2.0"

  # Development dependencies
  spec.add_development_dependency "bundler-audit", "~> 0.9"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "vcr", "~> 6.1"
  spec.add_development_dependency "rubocop", "~> 1.21"
end
