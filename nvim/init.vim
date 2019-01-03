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

" COMMAND LINE VS VIM
" vim is useful for looking at files
" reset?
"   mostly useful from history view (all, file)
"   reasonable from fuzzy history
" diff?
"   useful in many cases - need to see text
"   diff with stage
"   diff with HEAD
"   diff with HEAD^
"   diff with origin branch
"   diff with origin master
" interactively staging / unstaging changes, committing
" push / pull?
"   nope, never really
"
" VIEWS
"   History view
"     scroll through history with diff
"     in history window
"       reset (current, all)
"       checkout (current, all)
"   Fuzzy
"     branches
"     file history
"     branch history
"     ops -> reset, checkout, diff
"   Diff view
"     close -> close history if open? (stretch)
"     read [selected]
"   Whenever
