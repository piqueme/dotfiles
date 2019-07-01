if g:motions_enabled
  xnoremap gpp {k
  nnoremap gpp {k
  xnoremap gpn }j
  nnoremap gpn }j

  " relies on indentwise
  " TODO: activate only for pythong
  nmap gip [-
  nmap gin ]+
  nmap gmp [=
  nmap gmn ]=

  """ CLOJURE
  " vim-sexp
  " <f >f (move form)
  nmap <leader>ffr >f
  nmap <leader>ffl <f
  " >e <e (move element)
  nmap <leader>fer >e
  nmap <leader>fel <e
  " >( <( (barf left, slurp left)
  nmap <leader>fbl >(
  nmap <leader>fbr <)
  " >) <) (slurp right, barf right)
  nmap <leader>fsl <(
  nmap <leader>fsr >)
  " <I >I (insert at beginning, insert at end)
  nmap <leader>fib <I
  nmap <leader>fie >I
endif
