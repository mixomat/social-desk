require 'rubygems'
require 'sinatra'
require "sinatra/reloader" if development?
require 'twitter'
require "redis"
require 'haml'
require 'lib/twitter_stream'

set :public, File.dirname(__FILE__) + '/public'

configure do
  # initialize redis connection
  @@redis = Redis.new(:host => 'localhost', :port => 6379)
  
  # initialize twitter stream
  @@stream = TwitterStream.new
   @@stream.lists.each do |list|
     @@redis.sadd('user:marc:lists', list.name)
   end
end

get '/' do
  @lists = @@redis.smembers('user:marc:lists')
  haml :index
end

