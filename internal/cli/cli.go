package cli

import (
	"bufio"
	"context"
	"fmt"
	"os"

	"claude-test/internal/anthropic"
	"claude-test/internal/config"
)

type CLI struct {
	client *anthropic.Client
	config *config.Config
}

func New(client *anthropic.Client, cfg *config.Config) *CLI {
	return &CLI{
		client: client,
		config: cfg,
	}
}

func (c *CLI) Run(ctx context.Context) error {
	fmt.Println("Claude API Test Client")
	fmt.Printf("Model: %s, Max Tokens: %d\n", c.config.Model, c.config.MaxTokens)
	fmt.Println("Type your message (or 'quit' to exit):")
	fmt.Print("> ")

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		input := scanner.Text()
		if input == "quit" {
			break
		}

		response, err := c.client.SendMessage(ctx, c.config.Model, c.config.MaxTokens, input)
		if err != nil {
			fmt.Printf("Error: %v\n", err)
		} else {
			fmt.Printf("\nClaude: %s\n", response)
		}
		fmt.Print("\n> ")
	}

	if err := scanner.Err(); err != nil {
		return fmt.Errorf("reading input: %w", err)
	}

	return nil
}
