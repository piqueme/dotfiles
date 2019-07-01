""" ANNOTATION
" Commentary Plug https://github.com/tpope/vim-commentary/issues/84
if g:annotation_enabled
  function! UnmapCommentaryDefaults()
    unmap gc
    nunmap gcc
    nunmap gcu
  endfunction

  nmap <leader>dc <Plug>Commentary
  vmap <leader>dc <Plug>Commentary

  nmap a <Nop>
  xmap ac <Plug>Commentary
  nmap ac <Plug>Commentary
  omap ac <Plug>Commentary

  augroup commentary_remap
    autocmd!
    autocmd VimEnter * call UnmapCommentaryDefaults()
  augroup END
endif
