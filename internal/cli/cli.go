package cli

import (
	"context"
	"flag"
	"fmt"
	"os"
	"strings"

	"claude-test/internal/anthropic"
)

type CLI struct {
	apiKey    string
	model     string
	maxTokens int
	prompt    string
}

func NewCLI() *CLI {
	return &CLI{
		model:     "claude-sonnet-4-20250514",
		maxTokens: 1024,
	}
}

func (c *CLI) Parse(args []string) error {
	fs := flag.NewFlagSet("claude-test", flag.ContinueOnError)
	fs.Usage = c.usage(fs)

	fs.StringVar(&c.apiKey, "apikey", os.Getenv("ANTHROPIC_API_KEY"), "Anthropic API key (or set ANTHROPIC_API_KEY)")
	fs.StringVar(&c.model, "model", c.model, "Model to use")
	fs.IntVar(&c.maxTokens, "maxtokens", c.maxTokens, "Max tokens in response")

	if err := fs.Parse(args); err != nil {
		return err
	}

	if c.apiKey == "" {
		fs.Usage()
		return fmt.Errorf("API key is required: use -apikey flag or set ANTHROPIC_API_KEY")
	}

	remaining := fs.Args()
	if len(remaining) == 0 {
		fs.Usage()
		return fmt.Errorf("prompt is required")
	}

	if len(remaining) > 1 {
		fs.Usage()
		return fmt.Errorf("too many arguments")
	}

	c.prompt = remaining[0]
	return nil
}

func (c *CLI) usage(fs *flag.FlagSet) func() {
	return func() {
		var b strings.Builder
		b.WriteString("claude-test - CLI tool to interact with Claude API\n\n")
		b.WriteString("usage: claude-test [options] <prompt>\n\n")
		b.WriteString("options:\n")
		fs.SetOutput(&b)
		fs.PrintDefaults()
		fs.SetOutput(os.Stderr)
		b.WriteString("\nexamples:\n")
		b.WriteString("  claude-test \"Hello Claude\"\n")
		b.WriteString("  claude-test -model=claude-haiku-3-5-20241022 \"What is 2+2?\"\n")
		b.WriteString("  claude-test -apikey=sk-... -maxtokens=2048 \"Write a poem\"\n")
		fmt.Fprintln(os.Stderr, b.String())
	}
}

func (c *CLI) Run(ctx context.Context) error {
	client := anthropic.NewClient(c.apiKey)

	response, err := client.SendMessage(ctx, c.model, c.maxTokens, c.prompt)
	if err != nil {
		return err
	}

	fmt.Println(response)
	return nil
}
