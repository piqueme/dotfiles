""" GIT
" TODO: helpers for viewing diff between two refs
" TODO: inline maps from fugitive and gitv here for clarity
" TODO: learn how to rebase using gitv
if g:git_enabled
  set diffopt+=vertical
  let g:Gitv_DoNotMapCtrlKey = 1
  " depends on vim-fugitive
  nnoremap <leader>gs :Gstatus<cr>
  " fetch
  nnoremap <leader>gf :Gfetch<cr>
  " vertical diff current - staged
  nnoremap <leader>gds :Gvdiff<cr>
  " vertical diff current - HEAD
  nnoremap <leader>gdp :Gvdiff HEAD^<cr>
  " vertical diff current - origin
  nnoremap <leader>gdo :Gvdiff @{upstream}<cr>
  " vertical diff current - master
  nnoremap <leader>gdm :Gvdiff master<cr>
  " short mappings for taking / removing diff changes
  nnoremap <leader>gr :Gread<cr>
  vnoremap <leader>gr :diffget<cr>
  nnoremap <leader>gw :Gwrite<cr>
  vnoremap <leader>gw :diffput<cr>

  " git history view
  nnoremap <leader>gh :Gitv!<cr>
  vnoremap <leader>gh :Gitv!<cr>
  nnoremap <leader>gl :Gitv<cr>
  " submaps
  " o - open in split
  " s - open in vsplit
  " q - quit
  " co - checkout (file mode file only)
  " D - diff mode (file mode only)
  " D - visual mode, can diff file across range
  " S - diff state, works in visual too
  " " git fuzzy history

  nnoremap <leader>gf :GHistory<cr>
  " git fuzzy branches
  nnoremap <leader>gb :GBranches<cr>
  let g:signify_vcs_list = [ 'git' ]
  nmap <leader>gn <Plug>(signify-prev-hunk)
  nmap <leader>gm <Plug>(signify-next-hunk)
  nmap <leader>gt 9999<leader>gn
  omap ig <Plug>(signify-motion-inner-pending)
  xmap ig <Plug>(signify-motion-inner-visual)
  omap ag <Plug>(signify-motion-outer-pending)
  xmap ag <Plug>(signify-motion-outer-visual)

  " FZF HELPERS
  function! s:function(name)
    return function(a:name)
  endfunction

  function! s:commits_sink(lines)
    if len(a:lines) < 2
      return
    endif

    let shapattern = '[0-9a-f]\{7,9}'
    let action_map = {
    \ 'enter': 'diff',
    \ 'ctrl-e': 'checkout'
    \}

    let action = get(action_map, a:lines[0], 'diff')
    let commit = a:lines[1]
    let sha = matchstr(commit, shapattern)
    if !empty(sha)
      if action == 'diff'
        execute 'Gvdiff' sha
      elseif action == 'checkout'
        let revfile = sha . ':%'
        execute 'Gread' revfile
      endif
    endif
  endfunction

  function! s:git_history()
    " TODO: make sure this only gets called from a git buffer

    let source = 'git log --color=always '.fzf#shellescape('--format=%C(auto)%h%d %s %C(green)%cr')
    let source .= ' --follow -- '.expand('%:p')
    echo source
    let command = 'GHistory'
    let options = {
    \ 'source': source,
    \ 'sink*': s:function('s:commits_sink'),
    \ 'options': ['--ansi', '--layout=reverse-list', '--inline-info', '--prompt', command.'> ',
    \   '--expect=enter,ctrl-e']
    \ }
    return options
  endfunction

  " FZF allowing for replacing file with old commit, or diffing
  command! GHistory call fzf#run(fzf#wrap(s:git_history()))

  function! s:branches_sink(lines)
    if len(a:lines) < 2
      return
    endif

    let action_map = {
    \ 'enter': 'checkout',
    \ 'ctrl-h': 'read',
    \ 'ctrl-j': 'diff',
    \ 'ctrl-k': 'merge',
    \ 'ctrl-l': 'delete'
    \ }

    let action = get(action_map, a:lines[0], 'checkout')
    let branch = a:lines[1]
    let branch_info_split = split(branch)
    let branch_name = branch_info_split[0]
    if !empty(branch_name)
      if action == 'checkout'
        execute 'Git checkout' branch_name
      elseif action == 'diff'
        execute 'Gvdiff' branch_name
      elseif action == 'read'
        let revfile = branch_name . ':%'
        execute 'Gread' revfile
      elseif action == 'merge'
        execute 'Gmerge' branch_name
      elseif action == 'delete'
        execute 'Git branch -D' branch_name
      endif
    endif
  endfunction

  function! s:git_branches()
    " TODO: make sure this only gets called from a git-controlled file buffer

    let source = 'git branch -vv'
    let command = 'GBranches'
    let options = {
    \ 'source': source,
    \ 'sink*': s:function('s:branches_sink'),
    \ 'options': ['--inline-info', '--prompt', command.'> ',
    \   '--expect=enter,ctrl-h,ctrl-j,ctrl-k,ctrl-l']
    \ }
    return options
  endfunction

  " FZF command for diffing file w/ branch or checking out branch
  command! GBranches call fzf#run(fzf#wrap(s:git_branches()))
endif
