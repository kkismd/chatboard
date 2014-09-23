Twitter.configure do |config|
  config.consumer_key       = ENV['TWITTER_APIKEY']
  config.consumer_secret    = ENV['TWITTER_APISECRET']
end