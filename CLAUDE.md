# claude-test

Go CLI for interacting with Claude API via Anthropic SDK.

## Build & Run

```bash
go build -o claude-api ./cmd/claude-api
./claude-api "your prompt here"
```

Options: `-apikey`, `-model`, `-maxtokens`

## Structure

- `cmd/claude-test/` - Entry point
- `internal/cli/` - CLI parsing and logic
- `internal/anthropic/` - API client wrapper

## Environment

Required: `ANTHROPIC_API_KEY`

## Code Style

Standard Go conventions. Run `go fmt ./...` before commits.
