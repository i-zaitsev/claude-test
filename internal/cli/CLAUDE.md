# internal/cli

CLI argument parsing and orchestration logic.

## Rules for this directory

- Use the standard `flag` package for argument parsing (no third-party CLI libraries)
- CLI struct fields should remain unexported (lowercase)
- Default model: claude-sonnet-4-20250514
- Default max tokens: 1024
- API key must come from -apikey flag OR ANTHROPIC_API_KEY env var

## Important patterns

- Parse() handles all flag parsing and validation
- Run() executes the main logic using context
- usage() returns a closure for custom help text

## When modifying

- Update usage examples if adding new flags
- Validate all required fields in Parse()
- Return wrapped errors with context
