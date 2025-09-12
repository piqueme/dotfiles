#!/bin/bash

function place_window() {
  local prev_window
  local new_window

  # Get the currently focused window ID before the new window appears
  prev_window=$(xdotool getwindowfocus)

  # Wait briefly for the new window to appear and get focus
  sleep 0.1
  new_window=$(xdotool getwindowfocus)

  # If this is a new window (different from previous)
  if [ "$new_window" != "$prev_window" ]; then
    # Move previous window to scratchpad (background it)
    i3-msg "[id=$prev_window] move scratchpad"
    
    # Ensure new window goes to the marked pane
    i3-msg "[id=$new_window] move to mark focused_pane"
    i3-msg "[con_mark=focused_pane] focus"
  fi
}

## INITIAL STATE
# Use i3-msg get-tree
# Get focused pane
# Get window for focused pane
#
## UPDATES
# change focus
#   change focused container
#   add window to focus stack
#   i3-msg set mark focused pane
# change new
#    i3-msg move to focused pane
#    pop prev focused window and move to scratchpad
#    add window to focus stack
# change remove
#    i3-msg move old focused window to focused pane
#    pop focused window


# TODO: Make sure to debounce
# Subscribe to window events and process them
i3-msg -t subscribe -m '[ "window" ]' | while read -r line; do
    if echo "$line" | grep -q '"change":"focus"'; then
        # Change Current Focused Pane
    fi

    # For new window events
    if echo "$line" | grep -q '"change":"new"'; then
        # Move New Window to Focus Pane
        # Move Old Window to Scratch Pad
    fi

    # For close window events
    if echo "$line" | grep -q '"change":"close"'; then
        # Move Old Window to Focus Pane
        # 
    fi
done

# Invariant:
#   Single Focused Pane / Window
#   Start: Left Focus
#   New: Create Window, Move New Window to Focus Pane, Move Old Window to Scratchpad
#   Close: Move Old Window to Focus Pane, Focus Other Pane

