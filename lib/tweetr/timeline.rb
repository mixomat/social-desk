module SocialStream
  class Tweetr
    
    class Timeline
      include SocialStream::Backend
          
      attr_reader :id, :tweets
  
      def initialize(id = nil)
        @id = id ||= next_id
        @tweets = []
      end
      
      def self.create(id, data)
        new().store(data)
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
          tweet = Tweet.create(tweet_data)
          @tweets << tweet
          redis.sadd(redis_key, tweet.id)
        end
        self
      end
  
      def to_s
        "#{@id}: #{@tweets}"
      end

    end
  end
end