#!/usr/bin/env bash

# Terminate already running bar instances.
# This works for bars with IPC support (expected).
polybar-msg cmd quit

# Launch the bar, piping information about the process to a log.
echo "---" | tee -a /tmp/polybar.log
polybar bar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bar launched..."
