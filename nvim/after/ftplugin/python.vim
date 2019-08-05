setlocal encoding=utf-8
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=79
setlocal expandtab
setlocal autoindent

" Describe lo-fi and hi-fi plugins
" Emit events lo-fi and hi-fi load?
" Do not directly call any plugins - wrap calls in functions which are run on demand
"   this is to make sure we don't try and run stuff before loading

""" check if Black available?
let g:black_linelength=79

nmap <silent> <leader>id <Plug>(coc-definition)
nmap <silent> <leader>ir <Plug>(coc-references)
nmap <silent> <leader>is :CocList outline<CR>
nmap <silent> <leader>iw :CocList symbols<CR>
nmap <silent> <leader>fm <Plug>(coc-format)
nmap <silent> <leader>fn <Plug>(coc-format-selected)
vmap <silent> <leader>fn <Plug>(coc-format-selected)
nmap <silent> <leader>ep <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>ep <Plug>(coc-diagnostic-next)
