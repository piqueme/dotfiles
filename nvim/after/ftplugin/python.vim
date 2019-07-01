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

nmap <leader>id <Plug>(coc-definition)
nmap <leader>ir <Plug>(coc-references)

