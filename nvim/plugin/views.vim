if g:views_enabled
  """ WINDOW UTILITIES
  nnoremap <leader>wo :only<cr>
  nnoremap <leader>wn <c-w>w
  nnoremap <leader>wp <c-w>W
  nnoremap <leader>wv :vsplit<cr>
  nnoremap <leader>ws :split<cr>
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
endif
