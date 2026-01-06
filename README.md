# claude-test

Simple CLI tool to interact with Claude API.

## Setup

1. Get an API key from [console.anthropic.com](https://console.anthropic.com/)
2. Set the environment variable:
   ```bash
   export ANTHROPIC_API_KEY="your-api-key"
   ```

## Build

```bash
go build -o claude-test ./cmd/claude-test
```

## Usage

```
claude-test [options] <prompt>
```

### Options

| Flag | Default | Description |
|------|---------|-------------|
| `-apikey` | `$ANTHROPIC_API_KEY` | Anthropic API key |
| `-model` | `claude-sonnet-4-20250514` | Model to use |
| `-maxtokens` | `1024` | Max tokens in response |

### Examples

```bash
# Using environment variable for API key
export ANTHROPIC_API_KEY="sk-ant-api03-..."
./claude-test "Hello Claude"

# Passing API key directly
./claude-test -apikey="sk-ant-api03-..." "What is 2+2?"

# Using a different model
./claude-test -model=claude-haiku-3-5-20241022 "Write a haiku"

# Combining options
./claude-test -apikey="sk-ant-api03-..." -model=claude-opus-4-20250514 -maxtokens=2048 "Explain quantum computing"
```
