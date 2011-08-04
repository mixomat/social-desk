require "rubygems"
require "bundler"
require "json"

root = File.expand_path(File.dirname(__FILE__))
require "#{root}/backend"
require "#{root}/tweetr/connection"
require "#{root}/tweetr/user"
require "#{root}/tweetr/timeline"
require "#{root}/tweetr/tweet"

module SocialStream
  class Tweetr
    
    include SocialStream::Tweetr::Connection
    
    attr_reader :user

    def initialize(screen_name)
      @user = User.create(:id => screen_name)
      @connection = connect
    end
    
    # Returns the current twitter client. If none has been created, will
    # create a new one.
    def client
      @connection ||= connect
    end
      
    def lists
      @user.update_lists(client.lists.lists) if @user.lists.empty?
      @user.lists
    end
    
    def list_timeline(list_id)
      return Timeline.load(list_id) if Timeline.exists? list_id
      
      Timeline.create(:id => list_id).update_timeline(client.list_timeline(list_id.to_i))
    end
    
    
  end
end




