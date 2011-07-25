module SocialStream
  class Tweetr
      
    class Tweet
      include SocialStream::Backend
                
      attr_reader :id, :text, :author
      
      def initialize(id = nil)
        @id = id ||= next_id
      end
      
      def self.create(tweet)
        new().store tweet
      end
      
      def self.load(id)
        new(id).load
      end
      
      def load
        @text = redis.get redis_attr_key(:text)
        @author = redis.get redis_attr_key(:author)
        self
      end
      
      def store(tweet)
        redis.set redis_attr_key(:text), tweet.text
        redis.set redis_attr_key(:author), tweet.user.screen_name
        load
      end
      
      def to_s
        "#{@id}: #{@text} (#{author})"
      end            
    end
    
  end
end