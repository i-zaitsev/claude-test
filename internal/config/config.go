package config

import (
	"fmt"
	"os"
	"strconv"
)

type Config struct {
	APIKey    string
	Model     string
	MaxTokens int
}

func Load() (*Config, error) {
	apiKey := os.Getenv("ANTHROPIC_API_KEY")
	if apiKey == "" {
		return nil, fmt.Errorf("ANTHROPIC_API_KEY environment variable not set")
	}

	model := os.Getenv("CLAUDE_MODEL")
	if model == "" {
		model = "claude-sonnet-4-20250514"
	}

	maxTokens := 1024
	if mt := os.Getenv("CLAUDE_MAX_TOKENS"); mt != "" {
		parsed, err := strconv.Atoi(mt)
		if err != nil {
			return nil, fmt.Errorf("invalid CLAUDE_MAX_TOKENS: %w", err)
		}
		maxTokens = parsed
	}

	return &Config{
		APIKey:    apiKey,
		Model:     model,
		MaxTokens: maxTokens,
	}, nil
}
