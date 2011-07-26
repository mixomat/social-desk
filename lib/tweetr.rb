require "rubygems"
require "bundler"

root = File.expand_path(File.dirname(__FILE__))
require "#{root}/backend"
require "#{root}/tweetr/connection"
require "#{root}/tweetr/lists"
require "#{root}/tweetr/timeline"
require "#{root}/tweetr/tweet"

module SocialStream
  class Tweetr
    
    include SocialStream::Tweetr::Connection
    
    attr_reader :user

    def initialize(user)
      @user = user
      @connection = connect
    end
    
    # Returns the current twitter client. If none has been created, will
    # create a new one.
    def client
      @connection ||= connect
    end
    
      
    def lists
      Lists.create(client.lists.lists) unless Lists.cached? @user
      Lists.load @user
    end
    
    def list_timeline(list)
      timeline_data = client.list_timeline list.name
      Timeline.create(list.id,timeline_data)
    end
    
    
  end
end




