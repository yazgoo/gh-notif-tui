View github notifications and PRs in vim via fzf
Supports multiple github accounts.

## Install

First install fzf and this plugin

```vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'yazgoo/gh-notif-tui', {'do': 'bundle install'}
```

## Configuration

In ~/.config/gh-notif-tui.json, define your credentials.

- `user` command to retrieve the name of the github user to filter PRs
- `password` command to retrieve the github auth credential
- `notes` command to retrieve the final id in `notification_referrer_id` (useful to have the notification shelf)
- `command` command to open an url (where `%` will be replaced by the URL.

```json
{
"creds": [
 {
 "user": "lpass show --user github-access-token-gh-notif-tui",
 "password": "lpass show --password github-access-token-gh-notif-tui",
 "notes": "lpass show --notes github-access-token-gh-notif-tui",
 "command": "firefox 'ext+container:name=Professionnel&url=%'"
 },
 {
 "user": "lpass show --user github-access-token-gh-notif-tui-perso",
 "password": "lpass show --password github-access-token-gh-notif-tui-perso",
 "notes": "lpass show --notes github-access-token-gh-notif-tui-perso",
 "command": "firefox 'ext+container:name=Personnel&url=%'"
 }
 ]
}
```

in your vimrc:

```vim
nnoremap <space>n :GhNotif<cr>
nnoremap <space>i :GhNotifPrs<cr>
```
