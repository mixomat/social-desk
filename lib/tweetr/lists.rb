module SocialStream
  class Tweetr
    module Lists
      
      def lists
       Loader.lists(client)
      end
      
      class Loader   
          include SocialStream::Backend
          
          def self.lists(twitter)
            update(twitter) unless cached?
            load
          end
          
          def self.load
            loaded_lists = Array.new
            self.redis.smembers(redis_key(:lists)).each do |id|
              loaded_lists << {:id => id, :name => self.redis.get("list:#{id}:name") }
            end
            loaded_lists
          end

          def self.update(twitter)
            twitter.lists.lists.each do |l|
              redis.sadd redis_key(:lists), l.id
              self.redis.set "list:#{l.id}:name", l.name
            end
          end

          def self.cached?
            redis.exists redis_key(:lists)
          end

          def self.redis_key(key)
            "user:#{@user}:#{key}"
          end
      end

    end
  end
end