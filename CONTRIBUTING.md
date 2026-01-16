# Contributing to Crush Sandbox

Thank you for your interest in contributing! We welcome contributions from everyone.

## How to Contribute

### Reporting Issues

If you find a bug or have a feature request:

1. Check existing [issues](https://github.com/wireless25/crush-sandbox/issues) to avoid duplicates
2. Use the [issue template](https://github.com/wireless25/crush-sandbox/issues/new) if available
3. Include:
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Environment information (macOS version, Docker version)

### Submitting Pull Requests

1. Fork the repository
2. Create a branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes
4. Test thoroughly:
   - Run `bash -n docker-sandbox-crush` to check syntax
   - Test all commands: `./docker-sandbox-crush run`, `clean`, `install`
   - Test with flags: `--version`, `--shell`, `--force`
5. Commit your changes with clear messages
6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
7. Open a pull request

### Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/wireless25/crush-sandbox.git
   cd crush-sandbox
   ```

2. Make the script executable:
   ```bash
   chmod +x docker-sandbox-crush
   ```

3. Test your changes:
   ```bash
   # Test help
   ./docker-sandbox-crush

   # Test version
   ./docker-sandbox-crush --version

   # Test syntax
   bash -n docker-sandbox-crush
   ```

### Code Style

- Follow existing bash conventions in the script
- Use 4 spaces for indentation
- Add comments for complex logic
- Keep functions small and focused
- Use descriptive variable names

### Testing

Since there are no automated tests, manual testing is essential:

- Test on macOS (primary target)
- Verify Docker Desktop is running
- Test with multiple workspace directories
- Test container reuse
- Test cache persistence
- Test with `--shell` flag for debugging

### Documentation

- Update README.md if you change user-facing behavior
- Update AGENTS.md if you change internal architecture
- Keep changelog for version changes

## Guidelines

### Do

- Write clear, concise commit messages
- Test your changes thoroughly
- Update documentation
- Be respectful and constructive

### Don't

- Make breaking changes without discussion
- Add dependencies without justification
- Change the project scope significantly without agreement
- Commit sensitive information

## Getting Help

If you need help:
1. Check the [README](README.md)
2. Review existing issues and pull requests
3. Ask questions in a new issue with the "question" label

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
