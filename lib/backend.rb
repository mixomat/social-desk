require "redis"

module SocialStream
  module Backend

    extend self
    
    # Accepts:
    #   1. A 'hostname:port' String
    #   2. A 'hostname:port:db' String (to select the Redis db)
    def redis=(server)
      case server
        when String
          host, port, db = server.split(':')
          @redis = Redis.new(:host => host, :port => port, :thread_safe => true, :db => db)
        else Redis
          @redis = server
      end
    end

    # Returns the current Redis connection. If none has been created, will
    # create a new one.
    def redis
      return @redis if @redis
      self.redis = Redis.respond_to?(:connect) ? Redis.connect : "localhost:6379"
      self.redis
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end

    
    module InstanceMethods
      def model
        self.class.name.split('::').last.downcase
      end
      
      def redis_key
        raise ArgumentError, "id instance variable is not set" if @id.nil?
        "#{model}:#{@id}"
      end
      
      def redis_attr_key(attribute)
        "#{redis_key}:#{attribute}"
      end
      
      def next_id
        redis.incr "next.#{model}.id"
      end
    end
    
    module ClassMethods 
      def model
         self.to_s.split('::').last.downcase
      end
      
      def redis
        SocialStream::Backend.redis
      end
        
      def cached?(id)
        redis.exists new(id).redis_key
      end
      
    end
    

  end
end