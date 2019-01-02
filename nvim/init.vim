call plug#begin('~/.config/nvim/plugged')

" color scheme
Plug 'dracula/vim', {'as': 'dracula'}

" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

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

