call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'dracula/vim', {'as': 'dracula'}

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" commentary (generic commenting)
Plug 'tpope/vim-commentary'

" Git
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'
Plug 'mhinz/vim-signify'

" basic motion
Plug 'tpope/vim-surround'
Plug 'michaeljsmith/vim-indent-object'
Plug 'jeetsukumaran/vim-indentwise'

call plug#end()

let mapleader = ';'

" color scheme settings
syntax on
set termguicolors
color dracula

" airline config
let g:airline_theme = 'dracula'

set tabstop=2
set shiftwidth=2
set expandtab

set number
set textwidth=100

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

nnoremap <leader>ff :FzfGFiles<cr>
nnoremap <leader>it :FzfTags<cr>
nnoremap <leader>bf :FzfBuffers<cr>
nnoremap <leader>gc :FzfCommits<cr>

""" FILE UTILITIES
nnoremap <leader>fw :wq<cr>
nnoremap <leader>fq :q<cr>
nnoremap <leader>fs :w<cr>

""" ANNOTATION
" depends on vim-commentary
nmap <leader>ac <Plug>Commentary
vmap <leader>ac <Plug>Commentary

""" GIT
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
vnoremap <leader>gr :Gread<cr>
nnoremap <leader>gw :Gwrite<cr>
vnoremap <leader>gw :Gwrite<cr>
" git history view
nnoremap <leader>gh :Gitv!<cr>
vnoremap <leader>gh :Gitv!<cr>
nnoremap <leader>gl :Gitv<cr>
" git fuzzy history
nnoremap <leader>gf :GHistory<cr>
" TODO: history fuzzy search w/ FZF
" TODO: fix broken gitv-fugitive incompatibility
let g:signify_vcs_list = [ 'git' ]
nmap <leader>gn <Plug>(signify-prev-hunk)
nmap <leader>gm <Plug>(signify-next-hunk)
nmap <leader>gb 9999<leader>gn
omap ig <Plug>(signify-motion-inner-pending)
xmap ig <Plug>(signify-motion-inner-visual)
omap ag <Plug>(signify-motion-outer-pending)
xmap ag <Plug>(signify-motion-outer-visual)

function! s:commits_sink(lines)
  if len(a:lines) < 2
    return
  endif

  let shapattern = '[0-9a-f]\{7,9}'
  let action_map = {
  \ 'ctrl-d': 'diff',
  \ 'ctrl-e': 'checkout'
  \}

  let action = get(action_map, a:lines[0], 'diff')
  let commit = a:lines[1]
  let sha = matchstr(commit, shapattern)
  if !empty(sha)
    if action == 'diff'
      execute 'Gvdiff' sha
    elseif action == 'checkout'
      execute 'Git' 'checkout' sha
    endif
  endif
endfunction

command! GHistory call fzf#run(fzf#wrap({
\ 'source': 'git log --color=always '.fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr'),
\ 'sink*': function('<sid>commits_sink'),
\ 'options': ['--ansi', '--layout=reverse-list', '--inline-info', '--prompt',
\   'GHistory> ', '--expect=ctrl-d,ctrl-e']
\ }))

