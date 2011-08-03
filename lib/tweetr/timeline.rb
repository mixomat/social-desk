require File.expand_path(File.join(File.dirname(__FILE__), 'tweet'))


module SocialStream
  class Tweetr
    
    class Timeline
      include SocialStream::Backend
          
      collection :tweets, SocialStream::Tweetr::Tweet
  
      def load
        redis.smembers(redis_key).each do |tweet_id|
          @tweets << Tweet.load(tweet_id)
        end
        self
      end
      
      def self.create_from_data(id, data)
        timeline = Timeline.create(:id => id)
        data.each do |tweet|
          timeline.tweets << Tweet.create(:id => tweet.id, :text => tweet.text, :author => tweet.user.screen_name)
        end
        timeline
      end

      def to_json(*args)
        {:id => id, :tweets => tweets}.to_json(*args)
      end
    end
    
  end
end