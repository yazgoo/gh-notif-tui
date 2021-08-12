#!/bin/env ruby
require 'erb'
require 'octokit'
require 'prettyprint'
require 'base64'
require 'terminal-table'
def credentials(what)
  cmd = ARGV[{user: 1, password: 2, notes: 3}[what]]
  res = `#{cmd}`.chomp
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
    x.html_url
  ]
end

def client
  Octokit::Client.new(access_token: credentials(:password))
end

def print_table(rows)
  table = Terminal::Table.new do |t|
    t.rows = rows
    t.style = {:border_top => false, :border_bottom => false, :border_left => false, :border_right => false }
  end
  puts table
end

if ARGV[0] == "fzf"
  res = `#{$0} | fzf`
  if res.size > 0
    url = res.split("|")[2]
    `firefox #{url}`
  end
elsif ARGV[0] == "prs"
  print_table client.search_issues("is:open is:pr author:#{credentials(:user)} archived:false sort:updated-desc").items.map { |x| pr_row(x) }
elsif ARGV[0] == "notif"
  print_table client.notifications.map { |x| notification_row(x) }
end
