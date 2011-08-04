require File.expand_path(File.join(File.dirname(__FILE__), 'tweet'))


module SocialStream
  class Tweetr
    
    class Timeline
      include SocialStream::Backend
      
      collection :tweets, SocialStream::Tweetr::Tweet
      
      def update_timeline(data)
        data.each do |tweet|
          tweets << Tweet.create(:id => tweet.id, :text => tweet.text, :author_name => tweet.user.screen_name, :author_avatar => tweet.user.profile_image_url)
        end
        tweets
      end

      def to_json(*args)
        {:id => id, :tweets => tweets}.to_json(*args)
      end
    end
    
  end
end