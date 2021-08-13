View and open github notifications and PRs in vim via fzf.

Supports multiple github accounts.

## Install

First install fzf and this plugin

```vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'yazgoo/gh-notif-tui', {'do': 'bundle install'}
```

## Configuration

In `~/.config/gh-notif-tui.json`, define your credentials.

- `user` command to retrieve the name of the github user to filter PRs
- `password` command to retrieve the github auth credential
- `notes` command to retrieve the final id in `notification_referrer_id` (useful to have the notification shelf). See section `Getting final_id`
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

## Getting `final_id`

`final_id` will allow to have the notification shelf when opening your notifications, which looks like this:

![notification shelf](notification-shelf.png "Notification shelf")

- Go to notification page `https://github.com/notifications?query=is%3Aunread`
- Get an URL from the notification list (e.g. `https://github.com/mixer/retrieval/pull/4?notification_referrer_id=MDE4Ok5vdGlmaWNhdGlvblRocmVhZDEzNTk4ODE4MzA6MjIzMDk4NQ%3D%3D`).
- Extract the `notification_referrer_id` parameter from the URL, replacing `%3D` with `=` (e.g. `MDE4Ok5vdGlmaWNhdGlvblRocmVhZDEzNTk4ODE4MzA6MjIzMDk4NQ==`)
. decode the `notification_referrer_id` (e.g. echo "MDE4Ok5vdGlmaWNhdGlvblRocmVhZDEzNTk4ODE4MzA6MjIzMDk4NQ==" | base64 -d)
- extract the `final_id` from the decoded string (e.g. `018:NotificationThread1359881830:2230985` => `2230985`)
