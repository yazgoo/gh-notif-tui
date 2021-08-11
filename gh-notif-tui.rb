require 'erb'
require 'octokit'
require 'prettyprint'
require 'base64'
require 'terminal-table'
# Provide authentication credentials
client = Octokit::Client.new(:access_token => `lpass show --password github-access-token-gh-notif-tui`.chomp)

# You can still use the username/password syntax by replacing the password value with your PAT.
# client = Octokit::Client.new(:login => 'defunkt', :password => 'personal_access_token')

# Fetch the current user
res = client.notifications.map { |x| 
  referer_id = ERB::Util.url_encode(Base64.encode64('018:NotificationThread' + x.id + ':88483628').chomp)
                                    url = x.subject.url.gsub("api.github.com/repos/", "github.com/").gsub("/pulls/", "/pull/")
                           [
                             x.repository.full_name,
                            "#{url}?notification_referrer_id=#{referer_id}",
                            x.subject.title
                            ]
}

puts Terminal::Table.new :rows => res
