"<fzf ghnotif>
let s:gh_notif_path = expand('<sfile>:p:h')

function! s:gh_notif_open_pr_output(line)
  let l:parser = split(a:line, "|")
  let l:url = l:parser[0]
  silent execute '!firefox ' . shellescape(l:url, 1)
endfunction

command! -bang -nargs=0 GhNotifPrs
  \ call fzf#vim#grep(s:gh_notif_path. '/../gh-notif-tui.rb prs "'.g:gh_notif_user_command.'" "'.g:gh_notif_password_command.'" "'.g:gh_notif_notes_command.'"', 0,
  \   {
  \     'sink': function('s:gh_notif_open_pr_output')
  \   },
  \   <bang>0
  \ )

function! s:gh_notif_open_output(line)
  let l:parser = split(a:line, "|")
  let l:url = l:parser[i]
  silent execute '!firefox ' . shellescape(l:url, 1)
endfunction

command! -bang -nargs=0 GhNotif
  \ call fzf#vim#grep(s:gh_notif_path. '/../gh-notif-tui.rb notif "'.g:gh_notif_user_command.'" "'.g:gh_notif_password_command.'" "'.g:gh_notif_notes_command.'"', 0,
  \   {
  \     'sink': function('s:gh_notif_open_output')
  \   },
  \   <bang>0
  \ )
"</fzf ghnotif>

" example usage:
" nnoremap <space>n :GhNotif<cr>
