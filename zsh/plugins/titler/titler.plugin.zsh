# Hook that sets the title for the current terminal window.
# Useful for window management - you can search by e.g. commands
# that terminals have recently run to switch context.
preexec() {
  # Get the command that's about to be executed
  local cmd=$1
  # Take first three words
  local short_cmd=$(echo "$cmd" | awk '{print $1, $2, $3}')
  # Update the terminal title
  echo -ne "\033]0;${short_cmd}\007"
}
