#!/bin/bash
# PreToolUse hook for Edit/Write tools
# Protects sensitive files from modification
# Exit 0: allow, Exit 2: block

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Log edit attempts
echo "[PRE-EDIT] $(date '+%H:%M:%S') $TOOL_NAME: $FILE_PATH" >> /tmp/claude-hooks.log

# Sensitive file patterns - BLOCK all modifications
BLOCKED_PATTERNS=(".env" ".env.local" ".env.production" ".env.development" "credentials.json" "secrets.json" "secrets.yaml" "secrets.yml" ".pem" ".key" ".crt" "id_rsa" "id_ed25519" "id_dsa" ".htpasswd" "shadow" "passwd")

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "BLOCKED: Cannot modify sensitive file '$FILE_PATH'" >&2
    exit 2
  fi
done

# Block modifications to settings.local.json (user's personal settings)
if [[ "$FILE_PATH" == *"settings.local.json"* ]]; then
  echo "BLOCKED: Cannot modify user's local settings" >&2
  exit 2
fi

# Warn about modifying hook scripts themselves
if [[ "$FILE_PATH" == *".claude/hooks/"* ]]; then
  echo "[PRE-EDIT] WARNING: Modifying hook script: $FILE_PATH" >> /tmp/claude-hooks.log
fi

exit 0
