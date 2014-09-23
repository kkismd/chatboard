Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_APIKEY'], ENV['TWITTER_APISECRET']
end