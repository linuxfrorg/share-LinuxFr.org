# encoding: utf-8

require "redis"
require "twitter"
require "yajl"


class ShareLinuxFr
  autoload :VERSION, "share-linuxfr/version"

  def self.run(base_url)
    instance = self.new(base_url)
    instance.start
  end

  def self.configure(options)
    Twitter.configure do |config|
      config.endpoint           = options['endpoint']
      config.consumer_key       = options['consumer_key']
      config.consumer_secret    = options['consumer_secret']
      config.oauth_token        = options['access_token']
      config.oauth_token_secret = options['access_token_secret']
    end
  end

  def initialize(base_url)
    @redis = Redis.new
    @base_url = base_url
  end

  def start
    @redis.subscribe("news") do |on|
      on.message do |chan,message|
        tweet Yajl::Parser.parse(message)
      end
    end
  end

  def tweet(news)
    title  = news['title'].slice(0, 115)
    status = "#{title}#{'…' if title != news['title']} #{@base_url}#{news['slug']}"
    Twitter.update status
  end

end
