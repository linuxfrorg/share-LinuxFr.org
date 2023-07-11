# encoding: utf-8

require "net/http"
require "redis"
require "twitter"
require "yajl"
require "bskyrb"

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
    @@client = Twitter::REST::Client.new do |config|
      config.consumer_key        = options['consumer_key']
      config.consumer_secret     = options['consumer_secret']
      config.access_token        = options['access_token']
      config.access_token_secret = options['access_token_secret']
    end
  end

  def self.configure_bsky(options)
    credentials = Bskyrb::Credentials.new(options['username'], options['password'])
    session = Bskyrb::Session.new(credentials, options['pds_url'])
    @@bsky = Bskyrb::RecordManager.new(session)
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
        post msg
      end
    end
  rescue Errno::ECONNREFUSED => err
    $stderr.puts "Connection to redis has been lost"
  end

  def tweet(news)
    title  = news['title'].slice(0, 115)
    status = "#{title}#{'…' if title != news['title']} #{@base_url}#{news['id']}"
    @@client.update status
  rescue => err
    puts "Error on twitter: #{err}"
    puts "\tstatus = #{status.inspect}"
  end

  def post(news)
    title  = news['title'].slice(0, 115)
    status = "#{title}#{'…' if title != news['title']} #{@base_url}#{news['id']}"
    post_uri = @@bsky.create_post(status)["uri"]
  rescue => err
    puts "Error on bsky: #{err}"
    puts "\tstatus = #{status.inspect}"
  end

end
