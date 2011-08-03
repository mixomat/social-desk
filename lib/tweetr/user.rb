require File.expand_path(File.join(File.dirname(__FILE__), 'list'))

module SocialStream
  class Tweetr
    class User
      include SocialStream::Backend
      
      collection :lists, List
      
      def update_lists(data)
        data.each do |entry|
          lists << List.create(:id => entry.id, :name => entry.name)
        end
        lists
      end
      
      def to_json(*args)
        { :id => id, :lists => lists }.to_json(*args)
      end
    end
  end
end