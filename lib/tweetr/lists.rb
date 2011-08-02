

module SocialStream
  class Tweetr
    
    class Lists
      include SocialStream::Backend
      
      attr_reader :id, :items
      
      def initialize(id)
        @id = id
      end

      def self.create(id, data)
        new(id).store data
      end

      def self.load(id)
        new(id).load
      end
      
      def load
        @items = redis.smembers(redis_key).inject([]) do |result,list_id|
          result << List.load(list_id)
        end
        self
      end
      
      def store(lists)
        @items = lists.inject([]) do |result, entry|
          redis.sadd redis_key, entry.id
          result << List.create(entry.id, entry)
        end
        self
      end
      
      def to_json(*args)
        { :id => id, :items => items }.to_json(*args)
      end
    end
    
    class List
      include SocialStream::Backend

      attr_reader :id, :name
      
      def initialize(id)
        @id = id
      end

      def self.create(id, data)
        new(id).store data
      end

      def self.load(id)
        new(id).load
      end
      
      def load
        @name = redis.get redis_attr_key(:name)
        self
      end

      def store(list)
        redis.set redis_attr_key(:name), list.name
        load
      end
      
      def to_json(*args)
        { :id => id, :name => name }.to_json(*args)
      end
    end

  end
end