
module SocialStream
  module Tweetr
    class Lists
      
      include SocialStream::Tweetr::Connection
      
      attr_reader :user

      def initialize(user)
        @client ||= connect
        @user = user
      
        # initialize redis connection
        @redis = Redis.new(:host => 'localhost', :port => 6379)
      end
      
      def lists
        update unless cached?
        load
      end
    
      def load
        if cached?
          loaded_lists = Array.new
          @redis.smembers(redis_key(:lists)).each do |id|
            loaded_lists << {:id => id, :name => @redis.get("list:#{id}:name") }
          end
          loaded_lists
        end
      end
    
      def update
        @client.lists.lists.each do |l|
          @redis.sadd redis_key(:lists), l.id
          @redis.set "list:#{l.id}:name", l.name
        end
      end
  
      def cached?
        @redis.exists redis_key(:lists)
      end
      
      def timeline(list)
        @client.list_timeline list[:name]
      end

      def redis_key(key)
        "user:#{@user}:#{key}"
      end
    
    end
  end
end