# VIM CONFIG

## Editing Contexts

### General

1. Git
2. Motion
  - lisp (slurp barf next-arg previous-arg
  - paragraph
  - sentence
3. Linting
4. Colors
5. Buffer Management
6. Window Management
7. Tab Management
8. Comments
9. Autocompletion

### Programming

1. Testing
2. Linting


### Levels

1. General
2. Language
3. "LISP"
4. "Writing"
5. "Scale"


### Concepts
1. Mappings are an interface to common functionality
2. How functionality is provided is context specific (e.g. by language)
  - testing
  - linting

### Functionality

1. Git
  - Search branches
    - checkout
    - diff
    - !delete
    - !rebase
  - View log
    - view message, author, time
    - checkout (detached)
    - diff (stat)
    - diff (file)
    - reset (soft, hard)
  - Handle staging
    - view status
    - add / remove from staging
    - commit (full, amend)
  - Jumping

2. Text search
  - Search in file (and jump)
  - Search / replace in file
  - Search in whole codebase (i.e. with ripgrep) (and jump)

3. Smart search
  - Symbols (file)
  - Symbols (project)

4. File management
  - Search files in project

5. Window management
  - open window left / right / top / bottom
  - move window left / right / top / bottom
  - focus window (goyo)
  - solo window
  - close window

6. Tab management
  - open tab
  - close tab
  - next / prev tab

7. Buffer management
  - search buffers
  - open buffer in window left / top
  - swap between alternate / current

8. Motion
  - between functions (symbols?)
  - between arguments
  - in / out block
  - words, sentences, paragrahs...
  - beginning / end of file
  - line
  - git changes
  - lint / compile errors

9. Writing
  - function snippet (args, body)
  - generally snippets

10. Intelligence
  - Go to definition
  - Go to type
  - Peek definition
  - Peek type
  - List references
    - Jump / open to side

11. Formatting
  - format file
  - format selection

12. Compilation
  - See compile errors and relevant sources

13. Testing
  - See test errors and relevant sources

14. Documentation
  - View docsstring for current symbol (or selection)

### Cases
1. "Lo-fi"
2. Language
3. Mac vs. Linux

#### Implementation
1. Separate for different language contexts
2. Each language context has two modes for lo-fi vs hi-fi (functions)
3. All "mac" vs "linux" functionality is handled inline
4. Plugin for widget configuration (e.g. tab moves complete)
5. Variables for "functionality" plugins
6. Variables for "external" plugins
7. Contexts - set availability of different plugins

#### Milestones
1. Load some plugins with global variable
2. Load plugins for each file type with global variable
3. Load plugins for each file type with edit command flag

#### Questions
1. How do I make some plugins work for some contexts and not others (e.g. Deoplete vs. COC for
   Python vs. JS)?
2. How can I avoid loading plugins in "lo-fi" editing mode? Global variable? Flag when starting vim?
3. Which plugins to load when? Widget customization (by lo vs hi, by language?)?
4. How to view sub-context mappings? e.g. mappings in autocomplete widget
5. Are widgets on their own expensive?

#### Widgets
1. Autocomplete (floating list)
2. Floating window (hint)
3. Notice line (hint)
4. Quickfix list
5. Location list
6. Fuzzy finder (needs fzf)
7. Gutter
8. [special] git status
9. [special] git browser

#### Generic
1. Git
  - provider to fuzzy (needs fzf)
  - full history in tab view (needs gitv)
  - status (needs fugitive)
  - motions (changes)
  - gutter

2. LSP
  - Symbol list provider (file)
  - Symbol list provider (project)
  - Go to definition
  - Go to type
  - Autocomplete provider
  - Open docs

#### Language
1. Motions
  - Python
  - Clojure
  - Javascript

2. Snippets

3. Formatting

4. Linting

#### Contextual
1. Global configuration - lofi vs hifi
2. Global configuration - enabled functionality
3. Each plugin gets mapped to global configuration values
4. Implicit (functionality -> plugin availability)
  - e.g. "linting" -> ALE, ALE-python...
5. Implicit (functionality -> sub-functionality)
  - E.g. "linting" -> floating window hints

### Modules
1. Mappings -> Functionality
2. Functionality
3. Context = Mappings -> Functionality
4. Base Context = plugin
5. Language Context
6. Lofi Context
7. Widget Context
8. Workflow = "choose functions and widgets" -> Go
9. Customization by language
10. Concern that perf very tied to plugin, not functionality
11. A bit of spread (for example some language context may be in main init vim file)
12. "plugins" -> flags
13. vimrc -> set flags (by args, system conditions, config settings)
14. plugins = settings, mappings, functionality
15. plugins = widget plugins + functionality plugins

### Reuse
1. Make sure you get Neovim
2. Move init.vim
3. Move .vim directory
4. Symlink (.config/nvim -> dotfiles/nvim)
5. Get fzf
6. Get rg
7. Get fd
8. Run plug-install
9. :CocInstall coc-python coc-json coc-tsserver
9. Move fzf files
10. Move zsh files
