require File.expand_path(File.join(File.dirname(__FILE__), 'list'))

module SocialStream
  class Tweetr
    class Lists
      include SocialStream::Backend
      
      collection :items, List
      
      def self.create_from_data(id, data)
        lists = Lists.create(:id => id)
        data.each do |entry|
          lists.items << List.create(:id => entry.id, :name => entry.name)
        end
        lists
      end
      
      def to_json(*args)
        { :id => id, :items => items }.to_json(*args)
      end
    end
  end
end