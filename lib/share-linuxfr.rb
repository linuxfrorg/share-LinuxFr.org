# encoding: utf-8

require "net/http"
require "redis"
require "twitter"
require "yajl"


class ShareLinuxFr
  autoload :VERSION, "share-linuxfr/version"

  def self.run(base_url)
    instance = self.new(base_url)
    loop do
      instance.start
      sleep 1
    end
  end

  def self.configure_twitter(options)
    Twitter.configure do |config|
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
        msg = Yajl::Parser.parse(message)
        puts "Publish a new message: #{msg.inspect}"
        tweet msg
      end
    end
  rescue Errno::ECONNREFUSED => err
    $stderr.puts "Connection to redis has been lost"
  end

  def tweet(news)
    title  = news['title'].slice(0, 115)
    status = "#{title}#{'…' if title != news['title']} #{@base_url}#{news['id']}"
    Twitter.update status
  rescue => err
    puts "Error on twitter: #{err}"
    puts "\tstatus = #{status.inspect}"
  end

end
