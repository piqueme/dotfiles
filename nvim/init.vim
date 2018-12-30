call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'dracula/vim', {'as': 'dracula'}

call plug#end()

syntax on
" color scheme settings
set termguicolors
color dracula

set tabstop=2
set shiftwidth=2
set expandtab

inoremap jk <esc>
vnoremap jk <esc> 
inoremap <esc> <nop>

