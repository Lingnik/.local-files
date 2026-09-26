#!/bin/bash
# Alert that a pinentry prompt is about to appear, then hand off to pinentry-mac.
# Sound is detached + stdio-silenced so it can't interfere with the Assuan
# protocol that pinentry speaks over stdin/stdout.
afplay /System/Library/Sounds/Hero.aiff >/dev/null 2>&1 &
exec /opt/homebrew/bin/pinentry-mac "$@"
