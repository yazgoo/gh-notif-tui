#!/bin/env ruby
require 'erb'
require 'octokit'
require 'prettyprint'
require 'base64'
require 'terminal-table'
def credentials(what)
  `lpass show --#{what} github-access-token-gh-notif-tui`.chomp
end

def notification_row(x)
  referer_id = ERB::Util.url_encode(Base64.encode64('018:NotificationThread' + x.id + ":#{credentials(:user)}").chomp)
  url = x.subject.url.gsub("api.github.com/repos/", "github.com/").gsub("/pulls/", "/pull/")
  [
   x.repository.full_name,
   x.subject.title,
   "#{url}?notification_referrer_id=#{referer_id}",
   ]
end

if ARGV[0] == "fzf"
  res = `#{$0} | fzf`
  if res.size > 0
    url = res.split("|")[3]
    `firefox #{url}`
  end
else
client = Octokit::Client.new(access_token: credentials(:password))
res = client.notifications.map { |x| notification_row(x) }
puts Terminal::Table.new :rows => res
end
