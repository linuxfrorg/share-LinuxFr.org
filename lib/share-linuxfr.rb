# encoding: utf-8

require "net/http"
require "redis"
require "twitter"
require "yajl"


class ShareLinuxFr
  autoload :VERSION, "share-linuxfr/version"

  def self.run(base_url)
    instance = self.new(base_url)
    instance.start
  end

  def self.configure_twitter(options)
    Twitter.configure do |config|
      config.endpoint           = options['endpoint']
      config.consumer_key       = options['consumer_key']
      config.consumer_secret    = options['consumer_secret']
      config.oauth_token        = options['access_token']
      config.oauth_token_secret = options['access_token_secret']
    end
  end

  def self.configure_identica(options)
    @@identica = options
    @@identica['uri'] = URI.parse("#{@@identica['endpoint']}/statuses/update.xml")
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
        dent msg
      end
    end
  end

  def tweet(news)
    title  = news['title'].slice(0, 115)
    status = "#{title}#{'…' if title != news['title']} #{@base_url}#{news['slug']}"
    Twitter.update status
  rescue => err
    puts "Error on twitter: #{err}"
    puts "\tstatus = #{status.inspect}"
  end

  def dent(news)
    title  = news['title'].slice(0, 105)
    status = "#{title}#{'…' if title != news['title']} #{@base_url}#{news['id']}"
    http = Net::HTTP.new(@@identica['uri'].host, @@identica['uri'].port)
    req = Net::HTTP::Post.new(@@identica['uri'].path)
    req.set_form_data 'status' => status
    req.basic_auth @@identica['username'], @@identica['password']
    res = http.request req
  rescue => err
    puts "Error on identica: #{err}"
    puts "\tstatus = #{status.inspect}"
  end

end
