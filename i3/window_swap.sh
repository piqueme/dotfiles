#!/bin/bash

# Get ID of the current window before launching rofi
CURRENT_WINDOW=$(xdotool getwindowfocus)

# Launch rofi and get the selected window's ID
SELECTED_WINDOW_INFO=$(rofi -show window -format 'i:s' -window-format '{id} {name}')
SELECTED_WINDOW=$(echo "$SELECTED_WINDOW_INFO" | cut -d' ' -f1)

# If a window was selected
if [ -n "$SELECTED_WINDOW" ]; then
  # Move current window to scratchpad
  i3-msg "[id=$CURRENT_WINDOW] move scratchpad"
  
  # Check if selected window is in scratchpad and bring it out
  i3-msg "[id=$SELECTED_WINDOW] scratchpad show"
  
  # Move selected window to the focused pane
  i3-msg "[id=$SELECTED_WINDOW] move to mark focused_pane"
  i3-msg "[con_mark=focused_pane] focus"
fi
