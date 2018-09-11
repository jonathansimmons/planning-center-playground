Slack.configure do |config|
  config.token = "xoxb-156446580339-3vmrJkYDNRrY989v5gi1RI49"
end

JARVIS = Slack::Web::Client.new
