call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'dracula/vim', {'as': 'dracula'}

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

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
nnoremap ;se :edit ~/.config/nvim/init.vim<cr>
nnoremap ;ss :source ~/.config/nvim/init.vim<cr>
nnoremap ;sp :PlugInstall<cr>

""" REFORMATTING
nnoremap ;rs :%s/\s\+$//e<cr>
nnoremap ;rp Go

