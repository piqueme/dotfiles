set ignorecase
set smartcase

let s:gitdir=systemlist('git rev-parse --show-toplevel')[0]
let s:fzf_project_dir_opts={ 'dir': s:gitdir }

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
if g:fuzzy_finder_enabled
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview(s:fzf_project_dir_opts, 'up:60%')
    \           : fzf#vim#with_preview(s:fzf_project_dir_opts, 'right:50%:hidden', '?'),
    \   <bang>0)

  function! GrepOperator(type)
    if a:type ==# 'v'
      execute "normal! `<v`>y"
    elseif a:type ==# 'char'
      execute "normal! `[v`]y"
    else
      return
    endif

    silent execute "Rg " . @@
  endfunction

  nnoremap gr :set operatorfunc=GrepOperator<cr>g@
  vnoremap gr :<c-u>call GrepOperator(visualmode())<cr>
endif

