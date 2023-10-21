#!/bin/bash

# Bespoke command for performantly creating an i3 workspace
# Creates the workspace at the largest workspace count + 1
i3-msg workspace $(($(i3-msg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))
