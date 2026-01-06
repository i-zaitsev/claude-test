#!/bin/bash
# Stop hook - runs when Claude finishes responding
# Exit 0: allow stop
# JSON with decision:block: force Claude to continue

INPUT=$(cat)
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

echo "[ON-STOP] $(date '+%H:%M:%S') Claude finishing" >> /tmp/claude-hooks.log

# Check if there are uncommitted Go formatting issues
if command -v gofmt &> /dev/null; then
  UNFORMATTED=$(gofmt -l . 2>/dev/null | head -5)
  if [[ -n "$UNFORMATTED" ]]; then
    echo "[ON-STOP] Unformatted files detected: $UNFORMATTED" >> /tmp/claude-hooks.log
    # Uncomment below to BLOCK stop until files are formatted:
    # cat << EOF
    # {"decision":"block","reason":"Unformatted Go files detected: $UNFORMATTED. Run go fmt ./..."}
    # EOF
    # exit 0
  fi
fi

# Log session end
echo "[ON-STOP] Session complete" >> /tmp/claude-hooks.log

exit 0
