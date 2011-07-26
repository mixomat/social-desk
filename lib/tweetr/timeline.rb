module SocialStream
  class Tweetr
    
    class Timeline
      include SocialStream::Backend
          
      attr_reader :id, :tweets
  
      def initialize(id = nil)
        @id = id
        @tweets = []
      end

      def self.create(id, data)
        new(id).store(data)
      end
  
      def self.load(id)
        new(id).load
      end
  
      def load
        redis.smembers(redis_key).each do |tweet_id|
          @tweets << Tweet.load(tweet_id)
        end
        self
      end
      
      def store(data)
        data.each do |tweet_data|
          @tweets << Tweet.create(tweet_data.id_str, tweet_data)
          redis.sadd(redis_key, tweet_data.id_str)
        end
        self
      end
  
      def to_s
        "#{@id}: #{@tweets}"
      end

      def to_json(*args)
        {:id => id, :tweets => tweets}.to_json(*args)
      end
    end
    
  end
end