#!/bin/bash
# PreToolUse hook for Bash commands
# Runs BEFORE bash commands execute
# Exit 0: allow, Exit 2: block (stderr shown to user)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Log all commands
echo "[PRE-BASH] $(date '+%H:%M:%S') Command: $COMMAND" >> /tmp/claude-hooks.log

# Block dangerous rm patterns
if [[ "$COMMAND" == *"rm -rf /"* ]] || [[ "$COMMAND" == *"rm -rf ~"* ]]; then
  echo "BLOCKED: Dangerous rm command not allowed" >&2
  exit 2
fi

# Sensitive file patterns to protect
SENSITIVE_PATTERNS=(".env" ".env.local" ".env.production" "credentials" "secrets" "api_key" "apikey" ".pem" ".key" "id_rsa" "id_ed25519")

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
  if [[ "$COMMAND" == *"$pattern"* ]]; then
    # Allow read-only commands (cat, less, head, tail for viewing)
    if [[ "$COMMAND" =~ ^(cat|less|head|tail|grep|rg)\ .*$ ]]; then
      echo "[PRE-BASH] WARNING: Reading sensitive file matching '$pattern'" >> /tmp/claude-hooks.log
    else
      echo "BLOCKED: Command involves sensitive file pattern '$pattern'" >&2
      exit 2
    fi
  fi
done

# Block direct writes to sensitive files
if [[ "$COMMAND" == *">"* ]] || [[ "$COMMAND" == *"echo"* ]] || [[ "$COMMAND" == *"tee"* ]]; then
  for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    if [[ "$COMMAND" == *"$pattern"* ]]; then
      echo "BLOCKED: Cannot write to sensitive files via bash" >&2
      exit 2
    fi
  done
fi

# Warn about git push to main
if [[ "$COMMAND" == *"git push"* ]] && [[ "$COMMAND" == *"main"* || "$COMMAND" == *"master"* ]]; then
  echo "[PRE-BASH] WARNING: Pushing to main/master branch" >> /tmp/claude-hooks.log
fi

exit 0
