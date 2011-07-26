require "rubygems"
require "sinatra"
require "sinatra/reloader" if development?
require "config"
require "haml"

get '/' do
  @lists = @@tweetr.lists
  haml :index
end

get '/lists' do
  @@tweetr.lists.to_json
end

get '/lists/:id/timeline' do
  timeline = @@tweetr.list_timeline params[:id]
  timeline.to_json
end

