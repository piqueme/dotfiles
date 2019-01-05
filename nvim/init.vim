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
Plug 'jeetsukumaran/vim-indentwise'
Plug 'AndrewRadev/splitjoin.vim'

call plug#end()

let mapleader = ';'

" color scheme settings
syntax on
set termguicolors
color dracula

" airline config
let g:airline_theme = 'dracula'

" spacing
set tabstop=2
set shiftwidth=2
set expandtab

" editor area
set number
set textwidth=100

" search
set ignorecase
set smartcase

" folding
set nofoldenable

""" MODE SWITCHING
inoremap jk <esc>
vnoremap jk <esc>
inoremap <esc> <nop>

""" CONFIG EDITING
nnoremap <leader>se :edit ~/.config/nvim/init.vim<cr>
nnoremap <leader>ss :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>sp :PlugInstall<cr>

""" REFORMATTING
nnoremap <leader>rs :%s/\s\+$//e<cr>
nnoremap <leader>rp Go

""" FZF
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'down': '~40%' }

""" FILE UTILITIES
nnoremap <leader>ff :FzfGFiles<cr>
nnoremap <leader>fw :wq<cr>
nnoremap <leader>fq :q<cr>
nnoremap <leader>fs :w<cr>
nnoremap <leader>fu :checktime<cr>
nnoremap <leader>fo :only<cr>

""" BUFFER UTILIIES
nnoremap <leader>bf :FzfBuffers<cr>
nnoremap <leader>ba :b#<cr>

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
      execute 'checktime'
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
nnoremap <leader>vw :Goyo<cr>

