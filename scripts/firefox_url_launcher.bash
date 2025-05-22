#!/usr/bin/env bash
#
# firefox-url-launcher - Browse Firefox history and open URLs with Rofi
#

# Check for required dependencies
check_dependencies() {
  local missing=0
  
  for cmd in sqlite3 rofi firefox; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Missing dependency: $cmd" >&2
      echo "On NixOS, you can install it with: nix-env -iA nixos.$cmd" >&2
      missing=1
    fi
  done
  
  return $missing
}

# Find the Firefox profile directory
find_profile_dir() {
  ls -d ~/.mozilla/firefox/*.default-release/ 2>/dev/null || \
  ls -d ~/.mozilla/firefox/*.default/ 2>/dev/null || \
  echo ""
}

# Query Firefox history
get_history() {
  local profile_dir="$1"
  local history_db="$profile_dir/places.sqlite"
  
  if [ ! -f "$history_db" ]; then
    return 1
  fi
  
  # Query directly with read-only mode
  sqlite3 "file:$history_db?immutable=true" "
    SELECT DISTINCT url, title 
    FROM moz_places 
    WHERE url LIKE 'http%' 
    ORDER BY frecency DESC, last_visit_date DESC 
    LIMIT 1000;
  " | while IFS='|' read -r url title; do
    if [ -n "$title" ]; then
      echo "$title [$url]"
    else
      echo "$url"
    fi
  done

}

# URL encode for search queries
urlencode() {
  local string="$1"
  local encoded=""
  
  for (( i=0; i<${#string}; i++ )); do
    local c="${string:i:1}"
    case "$c" in
      [a-zA-Z0-9.~_-]) encoded+="$c" ;;
      " ") encoded+="+" ;;
      *) encoded+="$(printf '%%%02X' "'$c")" ;;
    esac
  done
  
  echo "$encoded"
}

# Main function
main() {
  # Check dependencies
  if ! check_dependencies; then
    exit 1
  fi
  
  local profile_dir=$(find_profile_dir)
  local history=""
  
  if [ -n "$profile_dir" ]; then
    history=$(get_history "$profile_dir")
  fi
  
  # Add manual URL entry option
  if [ -z "$history" ]; then
    selection=$(echo -e "Enter a URL manually\nNo Firefox history available" | \
      rofi -dmenu -i -p "Firefox URL" -mesg "Type a URL to open it")
  else
    selection=$(echo -e "Enter a URL manually\n$history" | \
      rofi -dmenu -i -p "Firefox URL" -matching fuzzy)
  fi
  
  # Handle selection
  if [ -n "$selection" ] && [ "$selection" != "No Firefox history available" ]; then
    # Extract URL from selection
    if [[ "$selection" =~ \[(http[^\]]+)\] ]]; then
      url="${BASH_REMATCH[1]}"
    elif [[ "$selection" =~ ^https?:// ]]; then
      url="$selection"
    elif [[ "$selection" == "Enter a URL manually" ]]; then
      url=$(rofi -dmenu -i -p "Enter URL" -input /dev/null)
      if [ -z "$url" ]; then
        return
      fi
      
      # Add http:// if needed
      if [[ ! "$url" =~ ^https?:// ]]; then
        url="http://$url"
      fi
    else
      # Handle non-URL input
      if [[ "$selection" =~ ^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$ ]]; then
        url="http://$selection"
      else
        # Search for the term
        url="https://www.google.com/search?q=$(urlencode "$selection")"
      fi
    fi
    
    # Open URL in Firefox
    firefox "$url"
  fi
}

main
