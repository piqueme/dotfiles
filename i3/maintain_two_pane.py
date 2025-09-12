#!usr/bin/env python3
from __future__ import annotations

import argparse
import json
import pathlib

import i3ipc

## TODO: Check state invariant of i3 tree.

class TwoPaneQuerier():
    '''TwoPaneQuerier executes key actions for two pane window management like creating new windows.'''

    # Dictionary mapping window IDs to their pane ('left' or 'right')
    window_panes: dict[str, str]
    # List of window IDs ordered by focus time (most recently focused at the end)
    focus_history: list[str]

    def __init__(self, state_file: pathlib.Path) -> None:
        _read_state_from_file(state_file)

    def _read_state_from_file(self, state_file: pathlib.Path) -> None:
        """
        Read and deserialize the state from the state file.
        Returns True if successful, False otherwise.
        """
        if not state_file.exists():
            raise ValueError(f"State file {self.state_file} does not exist")
            
        with open(state_file, 'r') as f:
            state = json.load(f)
            
        # Validate the state structure
        if not isinstance(state, dict):
            raise ValueError(f"State in state file {self.state_file} could not be parsed.")
            
        if 'window_panes' in state and isinstance(state['window_panes'], dict):
            self.window_panes = state['window_panes']
        
        if 'focus_history' in state and isinstance(state['focus_history'], list):
            self.focus_history = state['focus_history']

    def _get_most_recent_window_in_pane(self, pane: str) -> str:
        """Helper to get the most recently focused window in a specific pane"""
        # Reverse the focus history to find the most recent window in the specified pane
        for window_id in reversed(self.focus_history):
            if window_id in self.window_panes and self.window_panes[window_id] == pane:
                return window_id
        return None

    def focus(self, direction: str) -> None:
        '''Switch focus to the most recent focused window in the given pane.'''
        if direction not in ['left', 'right']:
            raise ValueError(f"Direction must be 'left' or 'right', got {direction}")
        
        window_id = self._get_most_recent_window_in_pane(direction)
        if window_id:
            # Focus the window using i3 command
            self.i3.command(f'[con_id={window_id}] focus')
        else:
            # TODO: Handle this case - we should have some sort of sentinel window in each pane?
            raise RuntimeError(f"No window found in the {direction} pane")

    def new_window(self, app: str) -> None:
        '''Open the application in the pane with the most recent focused window (like i3-msg exec).'''
        # Determine which pane was most recently focused
        if not self.focus_history:
            # Default to left pane if no focus history
            target_pane = 'left'
        else:
            most_recent_window = self.focus_history[-1]
            target_pane = self.window_panes.get(most_recent_window, 'left')
        
        # First focus the target pane
        self.focus(target_pane)
        
        # Then execute the application
        self.i3.command(f'exec {app}')

    def remove_window(self, window_id: str | None = None) -> None:
        '''Remove the window and switch focus in the window's pane to the pane's previous recently-focused window'''
        if window_id is None:
            str(self.i3.get_tree().find_focused().id)
        elif window_id not in self.window_panes:
            raise ValueError(f"Window {window_id} not found in any pane")
        
        # Get the pane of the window to be removed
        pane = self.window_panes[window_id]
        
        # Find the next most recent window in the same pane
        next_window = None
        for wid in reversed(self.focus_history):
            if wid != window_id and wid in self.window_panes and self.window_panes[wid] == pane:
                next_window = wid
                break
        
        # Kill the window
        self.i3.command(f'[con_id={window_id}] kill')
        
        # Remove from our state
        if window_id in self.window_panes:
            del self.window_panes[window_id]
        if window_id in self.focus_history:
            self.focus_history.remove(window_id)
        
        # Focus the next window in the same pane if available
        if next_window:
            self.i3.command(f'[con_id={next_window}] focus')
        else:
            # TODO: Handle this case - potentially with a sentinel window in the pane.
            raise RuntimeError("Missing previous window in pane to focus after removing window")


    def swap_window(self) -> None:
        '''Move the window focused in the left pane to the right, and vice-versa move right pane window to left pane.'''
        # Get the most recent window in each pane
        left_window = self._get_most_recent_window_in_pane('left')
        right_window = self._get_most_recent_window_in_pane('right')
        
        if not left_window or not right_window:
            raise RuntimeError("Cannot swap windows: missing window in one or both panes")
        
        # Mark the windows for swapping
        self.i3.command(f'[con_id={left_window}] mark --add _swap_left')
        self.i3.command(f'[con_id={right_window}] mark --add _swap_right')
        
        # Move left window to right pane
        self.i3.command('[con_mark="_swap_left"] move window to mark right')
        # Move right window to left pane
        self.i3.command('[con_mark="_swap_right"] move window to mark left')
        
        # Update our state
        if left_window in self.window_panes:
            self.window_panes[left_window] = 'right'
        if right_window in self.window_panes:
            self.window_panes[right_window] = 'left'
        
        # Remove the temporary marks
        self.i3.command('unmark _swap_left')
        self.i3.command('unmark _swap_right')

    def open_window(self, window_id: str) -> None:
        '''Take the window specified, move it to the pane with the most recent focus, and focus the opened window.'''
        # Determine which pane was most recently focused
        if not self.focus_history:
            target_pane = 'left'
        else:
            most_recent_window = self.focus_history[-1]
            target_pane = self.window_panes.get(most_recent_window, 'left')
        
        # Move the window to the target pane
        self.i3.command(f'[con_id={window_id}] move window to mark {target_pane}')
        
        # Update our state
        self.window_panes[window_id] = target_pane
        
        # Focus the window
        self.i3.command(f'[con_id={window_id}] focus')


class TwoPaneManager():
    i3: i3ipc.Connection
    # Dictionary mapping window IDs to their pane ('left' or 'right')
    window_panes: dict[str, str]
    # List of window IDs ordered by focus time (most recently focused at the end)
    focus_history: list[str]
    # File path to store the state for other processes.
    state_file: pathlib.Path

    def __init__(self, state_file: pathlib.Path):
        self.i3 = i3ipc.Connection()
        self.window_panes = {}
        self.focus_history = []
        self.state_file = state_file

        # Initialize the current state by getting all windows
        self._update_window_panes()

        # Write initial state
        self._write_state_to_file()

    def _update_window_panes(self):
        """Update the window_panes dictionary based on current i3 tree"""
        tree = self.i3.get_tree()
        for window in tree.leaves():
            # Determine pane by checking parent's mark
            parent = window.parent
            if parent and 'mark' in parent.ipc_data:
                if parent.ipc_data['mark'] == 'left':
                    self.window_panes[window.id] = 'left'
                elif parent.ipc_data['mark'] == 'right':
                    self.window_panes[window.id] = 'right'
            
            # Add to focus history if it's not already there
            if window.id not in self.focus_history:
                self.focus_history.append(window.id)

    def _write_state_to_file(self):
        """Serialize and write the current state to the state file"""
        state = {
            'window_panes': self.window_panes,
            'focus_history': self.focus_history
        }
        
        # Ensure the parent directory exists
        self.state_file.parent.mkdir(parents=True, exist_ok=True)
        
        # Write the state as JSON
        with open(self.state_file, 'w') as f:
            json.dump(state, f)

    def start_focus_listener(self) -> None:
        # Subscribe to window focus events
        self.i3.on(i3ipc.Event.WINDOW_FOCUS, self.handle_focus_event)
        # Start the event listener in a non-blocking way
        self.i3.main()

    def handle_focus_event(self, event) -> None:
        # Get the focused window ID
        window_id = event.container.id
        
        # Update all window panes to ensure we have the latest state
        self._update_window_panes()
        
        # Update focus history
        # Remove the window ID if it's already in the history
        if window_id in self.focus_history:
            self.focus_history.remove(window_id)
        
        # Add the window ID to the end of the list (most recently focused)
        self.focus_history.append(window_id)

        # Write the updated state to the file
        self._write_state_to_file()

def setup_parser():
    parser = argparse.ArgumentParser(description='2-pane window management utility')
    # Add state_file as a global argument
    parser.add_argument('--state_file', type=str, help='Path to the state file', default=(os.environ.get("XDG_STATE_HOME", "~/.local/state/") + 'two_pane_state.json'))

    subparsers = parser.add_subparsers(dest='command', help='Commands')
    
    new_parser = subparsers.add_parser('new_window', help='Creates a new window for an application in the current-focused pane')
    new_parser.add_argument('--app', type=str, help='Name of application to create window for')
    
    open_parser = subparsers.add_parser('open_window', help='Open an existing window')
    open_parser.add_argument('window_id', type=str, help='ID of the window to open')
    
    remove_parser = subparsers.add_parser('remove_window', help='Remove a window')
    remove_parser.add_argument('--window_id', type=str, help='optional ID of the window to remove')
    
    focus_parser = subparsers.add_parser('focus', help='Focus on window in a pane')
    focus_parser.add_argument('direction', type=str, choices=['left', 'right'], help='pane side to focus')
    
    swap_parser = subparsers.add_parser('swap_window', help='Swap two windows')

    start_daemon = subparsers.add_parser('start_daemon', help='Start the daemon process tracking focus state changes') 
    
    return parser

def main():
    parser = setup_parser()
    args = parser.parse_args()
    
    if args.command is None:
        parser.print_help()
        return

    if args.command == 'start_daemon':
        two_pane_manager = TwoPaneManager(state_file=pathlib.Path(args.state_file))
        two_pane_manager.start_focus_listener()
    elif args.command == 'new_window':
        two_pane_querier = TwoPaneQuerier(state_file=pathlib.Path(args.state_file))
        two_pane_querier.new_window(app=args.app)
    elif args.command == 'remove_window':
        two_pane_querier = TwoPaneQuerier(state_file=pathlib.Path(args.state_file))
        two_pane_querier.remove_window(window_id=(args.window_id or None))
    elif args.command == 'open_window':
        two_pane_querier = TwoPaneQuerier(state_file=pathlib.Path(args.state_file))
        two_pane_querier.open_window(window_id=args.window_id)
    elif args.command == 'focus':
        two_pane_querier = TwoPaneQuerier(state_file=pathlib.Path(args.state_file))
        two_pane_querier.focus(direction=args.direction)
    elif args.command == 'swap_window':
        two_pane_querier = TwoPaneQuerier(state_file=pathlib.Path(args.state_file))
        two_pane_querier.swap_window()


    print(f"Command: {args.command}")
    print(f"Arguments: {args}")

if __name__ == "__main__":
    main()

## SETUP
# Start a tree like:
# root
#   pane1 - tabbed (mark = focused_pane)
#     alacritty (focused = true)
#   pane2 - tabbed
#     firefox
#
#
# Operations
#   New Window
#       Get the previous-focused pane (left / right) and add the window to the layout.
#   Switch Window
#       Get the previous-focused pane (left / right) and open the chosen window in the layout, _or_ move it between panes.
#   Remove Window
#       Remove the current-focused window, replacing it with the latest window in focus history _not_ already visible.
#   Swap Window
#       Switch the panes for the current-focused windows in each pane.
#   Switch Focus
#   Open Finder (for New/Switch)
#       Creates a floating window.
#
# State Mangaement
#   We need to easily access the focus history for windows and their current pane (left / right).
#   Option 1
#       We use a background process that updates the current windows after each operation (by subscribing to window events).
#       This can also track the focus history from focus events.
#       When we need to access this data in other scripts we read the dumped file.
#   Option 2
#       We use marks to track state.
#       This is simpler.
#       Unfortunately it will not handle the "window removal" case cleanly.
#       For the window removal case we'd probably need to resort to some random window popping up.
#
#   Core Operation
#       RefreshFocus
#       GetLastFocusedPane
#       GetLastFocusedWindow(Left | Right?, Exceptions?)

