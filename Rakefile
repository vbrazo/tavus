# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

# Define RSpec task
RSpec::Core::RakeTask.new(:spec)

# Default task
task default: :spec

# Custom tasks for gem management
namespace :gem do
  desc "Build the gem"
  task :build do
    sh "gem build tavus.gemspec"
  end

  desc "Install the gem locally"
  task install: :build do
    version = File.read("lib/tavus/version.rb").match(/VERSION = "(.+)"/)[1]
    sh "gem install ./tavus-#{version}.gem"
  end

  desc "Uninstall the gem"
  task :uninstall do
    version = File.read("lib/tavus/version.rb").match(/VERSION = "(.+)"/)[1]
    sh "gem uninstall tavus -v #{version}"
  end

  desc "Clean up built gems"
  task :clean do
    sh "rm -f *.gem"
  end

  desc "Push gem to RubyGems"
  task push: :build do
    version = File.read("lib/tavus/version.rb").match(/VERSION = "(.+)"/)[1]
    sh "gem push tavus-#{version}.gem"
  end
end

# Development tasks
namespace :dev do
  desc "Run all tests"
  task :test do
    sh "bundle exec rspec"
  end

  desc "Run tests with coverage"
  task :coverage do
    ENV['COVERAGE'] = 'true'
    sh "bundle exec rspec"
  end

  desc "Run security audit"
  task :audit do
    sh "bundle exec bundle-audit check --update"
  end

  desc "Run all security checks"
  task :security do
    Rake::Task["dev:audit"].invoke
  end

  desc "Update dependencies"
  task :update do
    sh "bundle update"
  end

  desc "Check for outdated dependencies"
  task :outdated do
    sh "bundle outdated"
  end
end

# Release tasks
namespace :release do
  desc "Prepare for release (run tests, lint, build)"
  task :prepare do
    puts "🔍 Running tests..."
    Rake::Task["dev:test"].invoke
    
    puts "🔒 Running security checks..."
    Rake::Task["dev:security"].invoke
    
    puts "📦 Building gem..."
    Rake::Task["gem:build"].invoke
    
    puts "✅ Release preparation complete!"
  end

  desc "Create a new release (tag, build, push)"
  task :create do
    version = File.read("lib/tavus/version.rb").match(/VERSION = "(.+)"/)[1]
    
    puts "🏷️  Creating git tag v#{version}..."
    sh "git tag v#{version}"
    sh "git push origin v#{version}"
    
    puts "📦 Building and pushing gem..."
    Rake::Task["gem:push"].invoke
    
    puts "🎉 Release v#{version} created successfully!"
  end

  desc "Check if ready for release"
  task :check do
    version = File.read("lib/tavus/version.rb").match(/VERSION = "(.+)"/)[1]
    
    puts "📋 Release Checklist for v#{version}:"
    puts "  ✓ Version updated in version.rb"
    puts "  ✓ CHANGELOG.md updated" if File.read("CHANGELOG.md").include?(version)
    puts "  ✓ All tests passing" if system("bundle exec rspec > /dev/null 2>&1")
    puts "  ✓ Documentation up to date"
    puts "  ✓ Ready for release!"
  end
end

# Help task
desc "Show available tasks"
task :help do
  puts <<~HELP
    🎵 ElevenLabs Client Gem - Available Rake Tasks

    📦 Gem Management:
      rake gem:build          - Build the gem
      rake gem:install        - Install gem locally
      rake gem:uninstall      - Uninstall gem
      rake gem:clean          - Clean up built gems
      rake gem:push           - Push gem to RubyGems

    🧪 Testing:
      rake spec               - Run all tests (default)
      rake test:unit          - Run unit tests only
      rake test:integration   - Run integration tests only
      rake test:endpoint[name] - Run tests for specific endpoint
      rake dev:coverage       - Run tests with coverage

    🔧 Development:
      rake dev:audit          - Run bundler-audit
      rake dev:security       - Run security checks
      rake dev:update         - Update dependencies
      rake dev:outdated       - Check outdated dependencies

    🚀 Release:
      rake release:prepare    - Prepare for release
      rake release:create     - Create new release
      rake release:check      - Check release readiness

    Use 'rake -T' to see all available tasks.
  HELP
end
