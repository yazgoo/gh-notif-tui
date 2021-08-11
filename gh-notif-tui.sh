#!/usr/bin/sh
url=$(ruby gh-notif-tui.rb | fzf | cut -d'|' -f3)
[ -z "$url" ] || firefox "$url"
