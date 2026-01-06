# cmd/claude-test

Entry point for the CLI application.

## Rules for this directory

- Keep main.go minimal - it should only initialize CLI and handle top-level errors
- All business logic belongs in internal/ packages
- Error handling: use os.Exit(1) for errors, os.Exit(0) for success
- Always use context.Background() for the root context

## Testing changes

After modifying main.go, always run:
```bash
go build -o claude-api ./cmd/claude-api
```
