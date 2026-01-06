# claude-test

Simple CLI tool to interact with Claude API.

## Setup

1. Get an API key from [console.anthropic.com](https://console.anthropic.com/)
2. Set the environment variable:
   ```bash
   export ANTHROPIC_API_KEY="your-api-key"
   ```

## Build & Run

```bash
go build -o claude-test ./cmd/claude-test
./claude-test
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `ANTHROPIC_API_KEY` | (required) | Your Anthropic API key |
| `CLAUDE_MODEL` | `claude-sonnet-4-20250514` | Model to use |
| `CLAUDE_MAX_TOKENS` | `1024` | Max tokens in response |
