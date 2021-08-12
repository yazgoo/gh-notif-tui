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
  referer_id = ERB::Util.url_encode(Base64.encode64('018:NotificationThread' + x.id + ":#{credentials(:notes)}").chomp)
  url = x.subject.url.gsub("api.github.com/repos/", "github.com/").gsub("/pulls/", "/pull/")
  [
   x.repository.full_name,
   x.subject.title,
   "#{url}?notification_referrer_id=#{referer_id}",
   ]
end

def pr_row(x)
  [
    x.title,
    x.url
  ]
end

def client
  Octokit::Client.new(access_token: credentials(:password))
end

def print_table(t)
  puts Terminal::Table.new :rows => t
end

if ARGV[0] == "fzf"
  res = `#{$0} | fzf`
  if res.size > 0
    url = res.split("|")[3]
    `firefox #{url}`
  end
elsif ARGV[0] == "prs"
  print_table client.search_issues("is:open is:pr author:#{credentials(:user)} archived:false sort:updated-desc").items.map { |x| pr_row(x) }
else
  print_table client.notifications.map { |x| notification_row(x) }
end
