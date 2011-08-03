module SocialStream
  class Tweetr
      
    class Tweet
      include SocialStream::Backend
      
      attribute :author 
      attribute :text
      
      def to_s
        "#{id}: #{text} (#{author})"
      end      
      
      def to_json(*args)
        {:id => id, :author => author, :text => text}.to_json(*args)
      end
            
    end
    
  end
end