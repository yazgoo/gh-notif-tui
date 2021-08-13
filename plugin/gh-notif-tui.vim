"<fzf ghnotif>
let s:gh_notif_path = expand('<sfile>:p:h')

function! GhNotifInternalGetCmdLine(what)
  return s:gh_notif_path . '/../gh-notif-tui.rb ' . a:what
endfunction

function! GhInternalOpenUrl(action, line)
  silent execute '!' . GhNotifInternalGetCmdLine('open ' . a:action . " " . shellescape(a:line, 1))
endfunction

function! s:gh_notif_open_pr_output(line)
  call GhInternalOpenUrl("prs", a:line)
endfunction

function! s:gh_notif_open_output(line)
  call GhInternalOpenUrl("notif", a:line)
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
