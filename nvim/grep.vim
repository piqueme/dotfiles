function! s:GrepOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[y`]
  else
    echo "Grep operator cannot work on multi-line strings."
    return
  endif

  silent execute "grep! -R " . shellescape(@@) . " ."
  copen

  let @@ = saved_unnamed_register
endfunction

nnoremap <leader>sq :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>sq :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:fuzzy_ripgrep(term, preview)
  let gitdir = system("git rev-parse --show-toplevel | tr -d '\\n'")
  let is_git_dir = v:shell_error
  if is_git_dir !=# 0
    throw "[fatal] file is not a git repository!"
  endif
  call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(a:term).' '.shellescape(gitdir),
  \   1,
  \   a:preview ? fzf#vim#with_preview('right:50%')
  \           : {},
  \   a:preview)
endfunction

function! s:FuzzyRGOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[y`]
  else
    echo "Grep operator cannot work on multi-line strings!"
    return
  endif
  let search_term = @@
  let @@ = saved_unnamed_register

  call s:fuzzy_ripgrep(search_term, 0)
endfunction

command! -bang -nargs=1 Rg call <SID>fuzzy_ripgrep("<args>", <bang>1)

nnoremap <leader>ss :set operatorfunc=<SID>FuzzyRGOperator<cr>g@
vnoremap <leader>ss :<c-u>call <SID>FuzzyRGOperator(visualmode())<cr>
nnoremap <leader>sh :call <SID>fuzzy_ripgrep(expand("<cWORD>"), 0)<cr>
nnoremap <leader>sf :Rg! 

