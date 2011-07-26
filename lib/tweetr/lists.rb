module SocialStream
  class Tweetr
    
    class Lists
      include SocialStream::Backend
      
      attr_reader :id, :items
      
      def initialize(id)
        @id = id
        @items = []
      end

      def self.create(id, data)
        new(id).store data
      end

      def self.load(id)
        new(id).load
      end
      
      def load
        redis.smembers(redis_key).each do |list_id|
          @items << List.load(list_id)
        end
        self
      end
      
      def store(lists)
        lists.each do |entry|
          redis.sadd redis_key, entry.id
          @items << List.create(entry.id, entry)
        end
        self
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
      
    end

  end
end