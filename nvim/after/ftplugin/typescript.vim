setlocal encoding=utf-8
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=79
setlocal expandtab
setlocal autoindent

nmap <silent> <leader>id <Plug>(coc-definition)
nmap <silent> <leader>it <Plug>(coc-type-definition)
nmap <silent> <leader>is :CocList outline<CR>
nmap <silent> <leader>iw :CocList symbols<CR>
nmap <silent> <leader>ir <Plug>(coc-references)
nmap <silent> <leader>fm <Plug>(coc-format)
nmap <silent> <leader>fn <Plug>(coc-format-selected)
vmap <silent> <leader>fn <Plug>(coc-format-selected)
nmap <silent> <leader>ep <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>ep <Plug>(coc-diagnostic-next)
