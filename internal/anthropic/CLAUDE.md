# internal/anthropic

Anthropic SDK wrapper for Claude API communication.

## Rules for this directory

- Use the official SDK: github.com/anthropics/anthropic-sdk-go
- Client struct wraps the SDK client
- All API calls must accept context.Context as first parameter
- Wrap SDK errors with additional context using fmt.Errorf

## API patterns

- Use anthropic.F() for required fields
- Use anthropic.NewUserMessage() for user messages
- Check message.Content length before accessing
- Handle ContentBlockTypeText specifically

## Error handling

- Return descriptive errors: "API request failed: %w"
- Check for empty responses explicitly
- Never expose raw SDK errors to users
