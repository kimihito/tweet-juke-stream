#!/usr/bin/env ruby
#-*- coding: utf-8 -*-
require 'tweetstream'
require 'net/http'
require 'uri'
require 'yaml'


def set_config_value
  if File.exists?('setting.yml')
    yaml = YAML.load_file('setting.yml')
  else
    yaml = "not working"
  end

  consumer_key = ENV['CONSUMER_KEY'] ? ENV['CONSUMER_KEY'] : yaml['TWITTER']['CONSUMER_KEY']

  consumer_secret = ENV['CONSUMER_SECRET'] ? ENV['CONSUMER_SECRET'] : yaml['TWITTER']['CONSUMER_SECRET']

  oauth_token = ENV['OAUTH_TOKEN'] ? ENV['OAUTH_TOKEN'] : yaml['TWITTER']['OAUTH_TOKEN']

  token_secret = ENV['TOKEN_SECRET'] ? ENV['TOKEN_SECRET'] : yaml['TWITTER']['TOKEN_SECRET']

  { consumer_key: consumer_key, consumer_secret: consumer_secret, oauth_token: oauth_token, token_secret: token_secret }

end

config_values = set_config_value

TweetStream.configure do |config|
  config.consumer_key = config_values[:consumer_key]
  config.consumer_secret = config_values[:consumer_secret]
  config.oauth_token = config_values[:oauth_token]
  config.oauth_token_secret = config_values[:token_secret]
  config.auth_method = :oauth
end

client = TweetStream::Client.new
p "working streaming"
client.track("#tweetjuke") do |status|
  Thread.new{
    name = status.user.screen_name
    image_url = status.profile_image_url
    text = status.text

    urls = []
    status.urls.each do |u|
      urls << u.expanded_url
    end
    # uri = URI.parse("http://tweet-juke.herokuapp.com/create")
    # Net::HTTP.post_form(uri, {"data" => {"name" => name, "image_url" => image_url, "text" => status.text, "urls" => urls }})
  }
end

client.userstream
