module SocialStream
  class Tweetr
    class Tweet
      include SocialStream::Backend
      
      attribute :author_name
      attribute :author_avatar
      attribute :text

      def to_json(*args)
        {:id => id, :author => {:name => author_name, :avatar => author_avatar }, :text => text}.to_json(*args)
      end
            
    end
    
  end
end