" TODO: tidy sectioning
" TODO: helper to collect todo into loclist
" TODO: separate config into modules
" TODO: search all instances of current word in file
" TODO: search all instances of current word in git project
" TODO: intelligence ops
"   TODO: grep project
"   TODO: grep file
"   TODO: search tags file
"   TODO: search tags project
"   TODO: go to definition
"   TODO: go to implementation

call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'dracula/vim', {'as': 'dracula'}

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'

" commentary (generic commenting)
Plug 'tpope/vim-commentary'

" Git
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'
Plug 'mhinz/vim-signify'

" Goyo
Plug 'junegunn/goyo.vim'

" basic editing
Plug 'tpope/vim-surround'
Plug 'michaeljsmith/vim-indent-object'
Plug 'jeetsukumaran/vim-indentwise' " consider replacing...
Plug 'AndrewRadev/splitjoin.vim'

" linting
Plug 'w0rp/ale'

" alignment
Plug 'junegunn/vim-easy-align'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" TODO: VIM-TEST

call plug#end()

let mapleader = ';'

" color scheme settings
syntax on
let g:dracula_italic=0
color dracula
highlight Normal ctermbg=None

" airline config
let g:airline_theme = 'dracula'

" spacing
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set autoindent
set smartindent

" editor area
set number
set textwidth=100
set lazyredraw
set visualbell
set scrolloff=10
set encoding=utf-8

" file state management
set autoread

" search
set ignorecase
set smartcase

" command completion
set wildmenu
set wildmode=full

" folding
set nofoldenable

""" MODE SWITCHING
inoremap jk <esc>
vnoremap jk <esc>
inoremap <esc> <nop>

""" MACROS
" qq to record, Q to replay
nnoremap Q @q

""" CONFIG EDITING
nnoremap <leader>pe :edit ~/.config/nvim/init.vim<cr>
nnoremap <leader>ps :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>pp :PlugInstall<cr>
nnoremap <leader>pm :map<cr>

""" REFORMATTING
nnoremap <leader>rs :%s/\s\+$//e<cr>
nnoremap <leader>rp Go

""" FZF
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'down': '~40%' }

""" WINDOW UTILITIES
nnoremap <leader>wo :only<cr>
nnoremap <leader>wn <c-w>w
nnoremap <leader>wp <c-w>W
nnoremap <leader>wv :vsplit
nnoremap <leader>ws :split
" these ones are a little special to mesh with tmux
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

""" BUFFER UTILIIES
nnoremap <leader>bf :FzfGFiles<cr>
nnoremap <leader>bb :FzfBuffers<cr>
nnoremap <leader>ba :b#<cr>
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bp :bprev<cr>
nnoremap <leader>bw :wq<cr>
nnoremap <leader>bq :q<cr>
nnoremap <leader>bs :w<cr>
nnoremap <leader>bu :checktime<cr>

""" TAB UTILITIES
nnoremap <leader>te :tabedit
nnoremap <leader>tq :tabclose<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tn :tabn<cr>
nnoremap <leader>tp :tabp<cr>

""" ANNOTATION
" depends on vim-commentary
nmap <leader>ac <Plug>Commentary
vmap <leader>ac <Plug>Commentary

""" GIT
" TODO: helpers for viewing diff between two refs
" TODO: inline maps from fugitive and gitv here for clarity
" TODO: learn how to rebase using gitv
set diffopt+=vertical
let g:Gitv_DoNotMapCtrlKey = 1
" depends on vim-fugitive
nnoremap <leader>gs :Gstatus<cr>
" fetch
nnoremap <leader>gf :Gfetch<cr>
" vertical diff current - staged
nnoremap <leader>gds :Gvdiff<cr>
" vertical diff current - HEAD
nnoremap <leader>gdp :Gvdiff HEAD^<cr>
" vertical diff current - origin
nnoremap <leader>gdo :Gvdiff @{upstream}<cr>
" vertical diff current - master
nnoremap <leader>gdm :Gvdiff master<cr>
" short mappings for taking / removing diff changes
nnoremap <leader>gr :Gread<cr>
vnoremap <leader>gr :diffget<cr>
nnoremap <leader>gw :Gwrite<cr>
vnoremap <leader>gw :diffput<cr>
" git history view
nnoremap <leader>gh :Gitv!<cr>
vnoremap <leader>gh :Gitv!<cr>
nnoremap <leader>gl :Gitv<cr>
" git fuzzy history
nnoremap <leader>gf :GHistory<cr>
" git fuzzy branches
nnoremap <leader>gb :GBranches<cr>
let g:signify_vcs_list = [ 'git' ]
nmap <leader>gn <Plug>(signify-prev-hunk)
nmap <leader>gm <Plug>(signify-next-hunk)
nmap <leader>gt 9999<leader>gn
omap ig <Plug>(signify-motion-inner-pending)
xmap ig <Plug>(signify-motion-inner-visual)
omap ag <Plug>(signify-motion-outer-pending)
xmap ag <Plug>(signify-motion-outer-visual)

function! s:function(name)
  return function(a:name)
endfunction

function! s:commits_sink(lines)
  if len(a:lines) < 2
    return
  endif

  let shapattern = '[0-9a-f]\{7,9}'
  let action_map = {
  \ 'enter': 'diff',
  \ 'ctrl-e': 'checkout'
  \}

  let action = get(action_map, a:lines[0], 'diff')
  let commit = a:lines[1]
  let sha = matchstr(commit, shapattern)
  if !empty(sha)
    if action == 'diff'
      execute 'Gvdiff' sha
    elseif action == 'checkout'
      let revfile = sha . ':%'
      execute 'Gread' revfile
    endif
  endif
endfunction

function! s:git_history()
  " TODO: make sure this only gets called from a git buffer

  let source = 'git log --color=always '.fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr')
  let source .= ' --follow -- '.'/home/obe/dotfiles/nvim/init.vim'
  let command = 'GHistory'
  let options = {
  \ 'source': source,
  \ 'sink*': s:function('s:commits_sink'),
  \ 'options': ['--ansi', '--layout=reverse-list', '--inline-info', '--prompt', command.'> ',
  \   '--expect=enter,ctrl-e']
  \ }
  return options
endfunction

" FZF allowing for replacing file with old commit, or diffing
command! GHistory call fzf#run(fzf#wrap(s:git_history()))

function! s:branches_sink(lines)
  if len(a:lines) < 2
    return
  endif

  let action_map = {
  \ 'enter': 'checkout',
  \ 'ctrl-h': 'read',
  \ 'ctrl-j': 'diff',
  \ 'ctrl-k': 'merge',
  \ 'ctrl-l': 'delete'
  \ }

  let action = get(action_map, a:lines[0], 'checkout')
  let branch = a:lines[1]
  let branch_info_split = split(branch)
  let branch_name = branch_info_split[0]
  if !empty(branch_name)
    if action == 'checkout'
      execute 'Git checkout' branch_name
    elseif action == 'diff'
      execute 'Gvdiff' branch_name
    elseif action == 'read'
      let revfile = branch_name . ':%'
      execute 'Gread' revfile
    elseif action == 'merge'
      execute 'Gmerge' branch_name
    elseif action == 'delete'
      execute 'Git branch -D' branch_name
    endif
  endif
endfunction

function! s:git_branches()
  " TODO: make sure this only gets called from a git-controlled file buffer

  let source = 'git branch -vv'
  let command = 'GBranches'
  let options = {
  \ 'source': source,
  \ 'sink*': s:function('s:branches_sink'),
  \ 'options': ['--inline-info', '--prompt', command.'> ',
  \   '--expect=enter,ctrl-h,ctrl-j,ctrl-k,ctrl-l']
  \ }
  return options
endfunction

" FZF command for diffing file w/ branch or checking out branch
command! GBranches call fzf#run(fzf#wrap(s:git_branches()))

""" DEOPLETE
let g:deoplete#enable_at_startup = 1

""" GOYO
function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set scrolloff=999
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  set scrolloff=10
  " TODO: look into fixing this hack for color scheme
  highlight Normal ctermbg=None
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <leader>vw :Goyo<cr>

""" QUICKFIX UTILITIES
nnoremap <leader>qo :copen<cr>
nnoremap <leader>qn :cnext<cr>
nnoremap <leader>qp :cprev<cr>
nnoremap <leader>qc :cclose<cr>
nnoremap <leader>lo :lopen<cr>
nnoremap <leader>ln :lnext<cr>
nnoremap <leader>lp :lprev<cr>
nnoremap <leader>lc :lclose<cr>

""" VIM-EASY-ALIGN
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

""" ALE (LINT)
nmap <leader>an <Plug>(ale_next_wrap)
nmap <leader>ap <Plug>(ale_previous_wrap)

""" SPLITJOIN
let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nnoremap <leader>es :SplitjoinSplit<cr>
nnoremap <leader>ej :SplitjoinJoin<cr>

""" MOTIONS
xnoremap gpp {k
nnoremap gpp {k
xnoremap gpn }j
nnoremap gpn }j

" relies on indentwise
nmap gip [-
nmap gin ]+
nmap gmp [=
nmap gmn ]=

let s:scriptdir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:grep_module = s:scriptdir . '/grep.vim'
exec "source " . s:grep_module

