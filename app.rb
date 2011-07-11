require 'rubygems'
require 'sinatra'
require "sinatra/reloader" if development?
require 'twitter'
require 'haml'

helpers do
  def followers screen_name
    id = Twitter.user(screen_name).id
    follower_ids = Twitter.follower_ids(id)
    Twitter.users(Array(follower_ids))
  end
end

get '/' do
  haml :index
end

get '/followers' do
  @followers = followers("mixomat")
  haml :following
end

