# encoding: utf-8

require "em-hiredis"
require "em-http-request"
require "em-http/middleware/oauth"
require "yajl"


class ShareLinuxFr
  autoload :VERSION, "share-linuxfr/version"

  def self.run(config)
    EM.run do
      instance = self.new(config)
      instance.start
    end
  end

  def initialize(config)
    @redis = EM::Hiredis.connect(config['redis'])
    @base_url = config['base_url']
    @twitter  = config['twitter']
    @identica = config['identica']
  end

  def start
    @redis.subscribe("news")
    @redis.on(:message) do |chan,message|
      news = Yajl::Parser.parse(message)
      tweet news
      dent  news
    end
  end

  def tweet(news)
    conn = EventMachine::HttpRequest.new(@twitter['url'])
    conn.use EventMachine::Middleware::OAuth, @twitter['oauth']
    title  = news['title'].slice(0, 115)
    status = "#{title}#{'…' if title != news['title']} #{@base_url}#{news['slug']}"
    http = conn.post :body => {:status => status}
    http.callback { puts "Tweet OK: #{status}" }
    http.errback  { puts "Tweet error #{http.response} for: #{status}" }
  end

  def dent(news)
    conn = EventMachine::HttpRequest.new(@identica['url'])
    conn.use EventMachine::Middleware::OAuth, @identica['oauth']
    title  = news['title'].slice(0, 105)
    status = "#{title}#{'…' if title != news['title']} #{@base_url}#{news['id']}"
    http = conn.post :body => {:status => status}
    http.callback { puts "Dent OK: #{status}" }
    http.errback  { puts "Dent error #{http.response} for: #{status}" }
  end

end
