# Contributing to Apache Superset Configuration

Thank you for your interest in improving this Apache Superset configuration!

## How to Contribute

### Reporting Issues

If you encounter any issues with the configuration:

1. Check existing issues to avoid duplicates
2. Provide detailed information:
   - Operating system and version
   - Docker/Docker Compose versions
   - Error messages and logs
   - Steps to reproduce

### Suggesting Enhancements

Have ideas to improve the configuration?

1. Open an issue describing the enhancement
2. Explain the use case and benefits
3. Provide examples if applicable

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Update documentation if needed
   - Test your changes thoroughly

4. **Commit your changes**
   ```bash
   git commit -m "Description of your changes"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**

## Development Guidelines

### Configuration Files

When modifying `superset_config.py`:
- Keep environment variables for sensitive data
- Add comments for complex settings
- Test with `python3 validate_config.py`
- Update `.env.example` if adding new variables

### Docker Configuration

When modifying Docker files:
- Test build with `docker-compose build`
- Verify services start correctly
- Check health checks are working
- Update documentation

### Scripts

When adding or modifying scripts:
- Add proper error handling
- Include usage instructions
- Make scripts executable (`chmod +x`)
- Test on clean environment

### Documentation

When updating documentation:
- Keep it clear and concise
- Include examples where helpful
- Update CHANGELOG.md
- Check for broken links

## Testing Checklist

Before submitting a PR, verify:

- [ ] Configuration validates: `make validate`
- [ ] Docker builds successfully: `make build`
- [ ] Services start correctly: `make start`
- [ ] Health checks pass: `make health`
- [ ] Can login to Superset UI
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated

## Code Style

### Python
- Follow PEP 8 guidelines
- Use meaningful variable names
- Add docstrings for functions
- Keep functions focused and small

### Bash
- Use `#!/bin/bash` shebang
- Add `set -e` for error handling
- Quote variables: `"$VARIABLE"`
- Add comments for complex logic

### YAML
- Use 2-space indentation
- Keep it readable with proper spacing
- Validate with `docker-compose config`

## Version Numbering

We follow Semantic Versioning (SemVer):
- MAJOR version for incompatible changes
- MINOR version for new features
- PATCH version for bug fixes

## Questions?

If you have questions about contributing:
- Check the README.md
- Review SETUP_VERIFICATION.md
- Open an issue for discussion

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.
