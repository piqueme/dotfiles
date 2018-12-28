call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'dracula/vim', {'as': 'dracula'}

call plug#end()

syntax on
" color scheme settings
set termguicolors
color dracula

set ts=2
set sw=2
set expandtab
imap jk <Esc>
