""" TODO
" Autocomplete
" Intelligence
" Sub-mappings
" NVIM directory structure documentation
" LOFI context management

""" DEPENDENCEIES
" FZF
" Git

" Functionalities
let g:linting_enabled = 1
let g:annotation_enabled = 1
let g:editor_enabled = 1
let g:completion_enabled = 1 " TODO
let g:intelligence_enabled = 1 " TODO
let g:git_enabled = 1
let g:formatting_enabled = 1
let g:motions_enabled = 1
let g:views_enabled = 1
let g:snippets_enabled = 1 " TODO
let g:system_enabled = 1

" Widgets
let g:status_line_enabled = 1
let g:fuzzy_finder_enabled = 1
let g:inline_hints_enabled = 1
let g:quickfix_enabled = 1

call plug#begin()

" color scheme
Plug 'dracula/vim', {'as': 'dracula'}

Plug 'leafgarland/typescript-vim'

" airline
if g:status_line_enabled
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
endif

" fzf
" Assumes FZF is generally installed
if g:fuzzy_finder_enabled
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
endif

" commentary (generic commenting)
Plug 'tpope/vim-commentary'

" Git
if g:git_enabled
  Plug 'tpope/vim-fugitive'
  Plug 'gregsexton/gitv'
  Plug 'mhinz/vim-signify'
endif

" View plugins - Goyo, Tmux
if g:views_enabled
  Plug 'junegunn/goyo.vim'
  Plug 'christoomey/vim-tmux-navigator'
endif

" basic editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'PeterRincker/vim-argumentative'
Plug 'michaeljsmith/vim-indent-object'
Plug 'jeetsukumaran/vim-indentwise' " consider replacing...
Plug 'AndrewRadev/splitjoin.vim'

" linting
if g:linting_enabled
  Plug 'w0rp/ale'
endif

if g:motions_enabled
  " Clojure
  Plug 'guns/vim-sexp'
  Plug 'tpope/vim-sexp-mappings-for-regular-people'
endif

if g:intelligence_enabled || g:completion_enabled
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
endif

if g:intelligence_enabled
  " Clojure
  Plug 'tpope/vim-fireplace', { 'for': 'clojure', 'on': 'FireplaceConnect' }
  Plug 'clojure-vim/async-clj-omni', { 'for': 'clojure' }
endif

" Python
if g:formatting_enabled
  Plug 'python/black', { 'for': 'python' }
endif

call plug#end()

" Basic editor management
let mapleader = ';'
inoremap jk <esc>
vnoremap q <esc>
inoremap <esc> <nop>
nnoremap Q @q
set autoread

" Theme
syntax on
let g:dracula_italic=0
color dracula
highlight Normal ctermbg=None
let g:airline_theme='dracula'
let g:airline_powerline_fonts=1
