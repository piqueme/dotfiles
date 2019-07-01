""" REFORMATTING
if g:formatting_enabled
  nnoremap <leader>fs :%s/\s\+$//e<cr>
  nnoremap <leader>fn Go

  """ SPLITJOIN
  " TODO: Activate for JavaScript only
  let g:splitjoin_split_mapping = ''
  let g:splitjoin_join_mapping = ''
  nnoremap <leader>es :SplitjoinSplit<cr>
  nnoremap <leader>ej :SplitjoinJoin<cr>
endif
