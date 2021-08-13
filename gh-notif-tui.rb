#!/bin/env ruby

require 'erb'
require 'octokit'
require 'base64'
require 'terminal-table'
require 'json'

$config = JSON.parse(File.read("#{ENV['HOME']}/.config/gh-notif-tui.json"))

def credentials
  $config["creds"].map do |item|
    Hash[item.map do |k, v|
      [k, (k == "command" ? v : `#{v}`).chomp]
    end]
  end
end

def notification_row(creds, x, i)
  referer_id = ERB::Util.url_encode(Base64.encode64('018:NotificationThread' + x.id + ":#{creds[ "notes" ]}").chomp)
  url = x.subject.url.gsub("api.github.com/repos/", "github.com/").gsub("/pulls/", "/pull/")
  [
   i,
   x.repository.full_name,
   x.subject.title,
   "#{url}?notification_referrer_id=#{referer_id}",
   ]
end

def pr_row(x, i)
  [
    i,
    x.title,
    x.html_url
  ]
end

def client creds
  Octokit::Client.new(access_token: creds[ "password" ])
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
elsif ARGV[0] == "open"
  # open i url 
  command = credentials[ARGV[1].to_i]["command"]
  puts command
  cmd = command.gsub("%", ARGV[2])
  puts cmd
  `#{cmd}`
elsif ARGV[0] == "prs"
  print_table (credentials.each_with_index.flat_map do |creds, i|
  client(creds).search_issues("is:open is:pr author:#{creds[ "user" ]} archived:false sort:updated-desc").items.map { |x| pr_row(x, i) }
  end)
elsif ARGV[0] == "notif"
  print_table(credentials.each_with_index.flat_map do |creds, i|
    client(creds).notifications.map { |x| notification_row(x, i) }
  end)
end
