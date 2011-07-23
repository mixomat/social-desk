require "rubygems"
require "sinatra"
require "sinatra/reloader" if development?
require "config"
require "haml"

get '/' do
  @lists = @@tweetr.lists
  haml :index
end

