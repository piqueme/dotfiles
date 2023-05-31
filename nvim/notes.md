# My Neovim

## Major Cases
1. Remote Editing
1. TMUX
1. Bazel Code Generation

## Core Tooling

### Languages
1. Go
1. SQL
1. Protobuf
1. Bazel
1. Python
1. TypeScript

### Workflows
#### Intelligence
1. Go to definition
  - text: no alternate
1. Hover / peek definition
  - text: no alternate
1. Hover / peek signature
  - text: no alternate
1. Find references (file) / searchable
  - text: grep (file), visual selection, word under cursor, telescope
1. Find references (workspace) / searchable
  - text: grep (file), visual selection, word under cursor, telescope
1. Find warn / error (file) / searchable
  - text: only syntax?
1. Find warn / error (workspace) / searchable
1. Format file (manual, on save)
1. Rename symbol under cursor (in file, in workspace)
  - text: search/replace (file, workspace)
1. (autocompletion)
  - path
  - bazel targets
  - some sort of configurations? ssh hosts?
1. (scrolling documentation in floating window)
1. (search examples in the web -> goto)

Hard part: handling generated code by `bazel`.

#### Version Control
1. View history (folder scope, scan diffstat, checkout, reset soft)
1. Check diffstat / diff between two commits (highlight in history)
1. Find changes (file) / marked / searchable
1. Find changes (workspace) / marked / searchable
1. Open PR, cycle through diff files
1. Resolve rebase conflicts in diff view

#### Test Client
1. HTTP Client
1. PromQL Client
1. SQL Client
1. GraphQL Client / Explorer

#### Basic Editing
1. Text Object (Function)
1. Surround
1. Commentary
1. Split-Join
1. (for LISP) ParEdit
1. Find/Replace (in file)
1. Find/Replace (in workspace)
1. View / Search by TreeSitter Query (file, workspace)

#### Unit Testing
1. Go to test file / source file (show options if multiple)
1. Run related tests (reverse dependency search)
  - show in tmux pane
  - show in buffer
1. Execute all tests

#### Debugger
1. Add / remove breakpoint
1. Run app with debugger
1. Step in / over / out
1. Start profiling / stop profiling

#### Documentation
1. Search mappings
1. Search READMEs
1. Search vim help
1. Search man pages
1. Easy ChatGPT / Google / tldr?

#### Buffer and Window Management
1. tabc / tabp / tabn
1. bp / bn / ba / bc
1. search files (with hidden)
1. search buffers
1. toggle file explorer
1. move between tmux panes
1. focus pane

#### Sharing
1. Screencast / ASCIICinema [DONE, separate, Docker]
1. "Copy code section" -> System Text, Image [DONE, separate, Flameshot, tmux]
1. Get Github link for code file / lines
1. Get Patch for current diff -> pastable
