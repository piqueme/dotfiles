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

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  " Relies on coc.nvim
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
endif
