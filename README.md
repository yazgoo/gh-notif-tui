view github notifications and PRs in vim via fzf

## Install

First install fzf and this plugin

```vimscript
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'yazgoo/gh-notif-tui'
```

## Configuration

```vimscript
" command to run to get username
let g:gh_notif_user_command = 'lpass show --user github-access-token-gh-notif-tui'
" command to run to auth token
let g:gh_notif_password_command = 'lpass show --password github-access-token-gh-notif-tui'
" command to run to get base64 decoded final id in `notification_referrer_id`
" when decoding base64 notification_referrer_id
" 018:NotificationThread42:final_id
let g:gh_notif_notes_command = 'lpass show --notes github-access-token-gh-notif-tui'
nnoremap <space>n :GhNotif<cr>
nnoremap <space>i :GhNotifPrs<cr>
```
