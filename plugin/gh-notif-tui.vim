"<fzf ghnotif>

function! GhNotifInternalGetCmdLine(what)
  return expand('<sfile>:p:h') . '/gh-notif-tui.rb ' . a:what
endfunction

function! GhInternalOpenUrl(i, url)
  silent execute '!' . GhNotifInternalGetCmdLine('open ' . a:i . ' ' . shellescape(a:url, 1))
endfunction

function! s:gh_notif_open_pr_output(line)
  let l:parser = split(a:line, "|")
  let l:url = l:parser[2]
  let l:i = l:parser[0]
  call GhInternalOpenUrl(l:i, l:url)
endfunction

function! s:gh_notif_open_output(line)
  let l:parser = split(a:line, "|")
  let l:url = l:parser[3]
  let l:i = l:parser[0]
  call GhInternalOpenUrl(l:i, l:url)
endfunction

command! -bang -nargs=0 GhNotifPrs
  \ call fzf#vim#grep(GhNotifInternalGetCmdLine('prs'), 0,
  \   {
  \     'sink': function('s:gh_notif_open_pr_output')
  \   },
  \   <bang>0
  \ )

command! -bang -nargs=0 GhNotif
  \ call fzf#vim#grep(GhNotifInternalGetCmdLine('notif'), 0,
  \   {
  \     'sink': function('s:gh_notif_open_output')
  \   },
  \   <bang>0
  \ )
"</fzf ghnotif>

" example usage:
" nnoremap <space>n :GhNotif<cr>
