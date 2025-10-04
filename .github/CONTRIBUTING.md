# Contributing to Tavus Ruby Client

Thank you for your interest in contributing to the Tavus Ruby client! We welcome contributions from the community.

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for everyone.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in the [Issues](https://github.com/upriser/tavus/issues)
2. If not, create a new issue using the bug report template
3. Provide as much detail as possible, including:
   - Ruby version
   - Gem version
   - Steps to reproduce
   - Expected vs actual behavior
   - Error messages and stack traces

### Suggesting Features

1. Check if the feature has already been requested
2. Create a new issue using the feature request template
3. Clearly describe the feature and its benefits
4. Provide example usage if possible

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Install dependencies**: `bundle install`
3. **Make your changes**:
   - Follow the existing code style
   - Add tests for new functionality
   - Update documentation as needed
4. **Run tests**: `bundle exec rspec`
5. **Run linter**: `bundle exec rubocop`
6. **Commit your changes**:
   - Use clear and descriptive commit messages
   - Reference related issues (e.g., "Fixes #123")
7. **Push to your fork** and submit a pull request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/tavus.git
cd tavus

# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop

# Run console for testing
bin/console
```

## Coding Standards

### Style Guide

- Follow the [Ruby Style Guide](https://rubystyle.guide/)
- Use RuboCop for linting (configuration in `.rubocop.yml`)
- Write clear, self-documenting code
- Add comments for complex logic

### Testing

- Write RSpec tests for all new features and bug fixes
- Maintain or improve code coverage
- Use descriptive test names
- Mock external API calls using WebMock/VCR

### Documentation

- Update README.md for user-facing changes
- Add YARD documentation for new methods
- Update CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/)
- Include code examples where appropriate

## Code Review Process

1. All pull requests require review before merging
2. Address review feedback promptly
3. Keep PRs focused and reasonably sized
4. Ensure CI checks pass

## Testing Your Changes

### Unit Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/tavus/client_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Linting

```bash
# Check for style violations
bundle exec rubocop

# Auto-fix violations
bundle exec rubocop -a
```

### Manual Testing

```bash
# Start interactive console
bin/console

# Test your changes
client = Tavus::Client.new(api_key: 'your-key')
# ... test functionality
```

## Project Structure

```
tavus/
├── lib/tavus/              # Source code
│   ├── resources/          # API resource implementations
│   ├── client.rb          # Main client
│   ├── configuration.rb   # Configuration management
│   └── errors.rb          # Error classes
├── spec/                   # RSpec tests
├── examples/               # Usage examples
└── docs/                   # Additional documentation
```

## Release Process

Releases are handled by maintainers:

1. Update version in `lib/tavus/version.rb`
2. Update CHANGELOG.md
3. Commit changes: `git commit -am "Release vX.Y.Z"`
4. Create tag: `git tag vX.Y.Z`
5. Push: `git push origin main --tags`
6. GitHub Actions will build and create the release

## Getting Help

- 📖 Read the [documentation](https://github.com/upriser/tavus/blob/main/README.md)
- 💬 Ask questions in [Discussions](https://github.com/upriser/tavus/discussions)
- 🐛 Report bugs in [Issues](https://github.com/upriser/tavus/issues)
- 📧 Contact maintainers for sensitive matters

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Recognition

Contributors will be recognized in:
- GitHub contributors page
- Release notes (for significant contributions)
- Special thanks in README (for major features)

Thank you for contributing! 🎉

