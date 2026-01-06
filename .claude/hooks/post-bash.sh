#!/bin/bash
# PostToolUse hook for Bash commands
# Runs AFTER bash commands complete
# Logs results and can add context for Claude

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
STDOUT=$(echo "$INPUT" | jq -r '.tool_response.stdout // empty')
STDERR=$(echo "$INPUT" | jq -r '.tool_response.stderr // empty')
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_response.exitCode // 0')

# Log command results
echo "[POST-BASH] $(date '+%H:%M:%S') Exit=$EXIT_CODE Command: $COMMAND" >> /tmp/claude-hooks.log

# If go build failed, add helpful context
if [[ "$COMMAND" == *"go build"* ]] && [[ "$EXIT_CODE" != "0" ]]; then
  cat << 'EOF'
{"hookSpecificOutput":{"additionalContext":"Build failed. Check: 1) go.mod dependencies 2) syntax errors 3) missing imports. Run 'go mod tidy' if needed."}}
EOF
fi

# If go test failed, add context
if [[ "$COMMAND" == *"go test"* ]] && [[ "$EXIT_CODE" != "0" ]]; then
  cat << 'EOF'
{"hookSpecificOutput":{"additionalContext":"Tests failed. Review test output carefully before making changes."}}
EOF
fi

exit 0
