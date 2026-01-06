package anthropic

import (
	"context"
	"fmt"

	"github.com/anthropics/anthropic-sdk-go"
	"github.com/anthropics/anthropic-sdk-go/option"
)

type Client struct {
	sdk *anthropic.Client
}

func NewClient(apiKey string) *Client {
	client := anthropic.NewClient(option.WithAPIKey(apiKey))
	return &Client{sdk: client}
}

func (c *Client) SendMessage(ctx context.Context, model string, maxTokens int, userMessage string) (string, error) {
	message, err := c.sdk.Messages.New(ctx, anthropic.MessageNewParams{
		Model:     anthropic.F(model),
		MaxTokens: anthropic.F(int64(maxTokens)),
		Messages: anthropic.F([]anthropic.MessageParam{
			anthropic.NewUserMessage(anthropic.NewTextBlock(userMessage)),
		}),
	})
	if err != nil {
		return "", fmt.Errorf("API request failed: %w", err)
	}

	if len(message.Content) == 0 {
		return "", fmt.Errorf("empty response from API")
	}

	for _, block := range message.Content {
		if block.Type == anthropic.ContentBlockTypeText {
			return block.Text, nil
		}
	}

	return "", fmt.Errorf("no text content in response")
}
