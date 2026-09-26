#!/bin/bash
# Alert before every `op` invocation, then hand off to the real op.
# Sound is detached + stdio-silenced so it can't interfere with op's
# stdin/stdout (e.g. `op run -- ...` or env-file parsing).
# Skipped for `op __complete ...` so shell completion stays quiet.
if [[ "$1" != "__complete" ]]; then
  afplay /System/Library/Sounds/Hero.aiff >/dev/null 2>&1 &
fi
exec /opt/homebrew/bin/op "$@"
