require "redis"
require "nest"

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

    # Returns the current Redis connection.
    # If none has been created, will create a new one.
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
      
      attr_accessor :id
      attr_reader :fresh
            
      def initialize(attrs = {})
        @id = initialize_id(attrs[:id])
        @fresh = true
        @attrs = Hash.new { |hash, key| hash[key] = load_attr(key) }
        update_attributes(attrs.reject{|k,v| k === :id})
      end
      
      def initialize_id(id)
        @id = id.to_s
      end
      
      def create
        store
        fresh = false
      end
      
      def store
        self.class.all.sadd id
        @attrs.each do |name,value|
          store_attr(name,value)
        end
      end
      
      def update_attributes(attrs)
        attrs.each do |key, value|
          send(:"#{key}=", value)
        end
      end
       
      def read_attr(name)
        @attrs[name]
      end
      
      def write_attr(name, value)
        @attrs[name] = value
      end
      
      def load_attr(name)
        #unless fresh?
          redis.get redis_attr_key(name)
        #end
      end
      
      def store_attr(name, value)
        write_attr(name, value)
        redis.set redis_attr_key(name), value
      end


      def model
        self.class.name.split('::').last.downcase
      end
      
      def key
        self.class.key[id]
      end
      
      def redis_key
        raise ArgumentError, "id instance variable is not set" if @id.nil?
        "#{model}:#{@id}"
      end
      
      def redis_attr_key(name)
        "#{redis_key}:#{name}"
      end
      
      def next_id
        redis.incr "next.#{model}.id"
      end

      
    end
    
    module ClassMethods
  
      # Attributes class variable, which contains an array of attributes for each class.  
      #
      @@attributes  = Hash.new { |hash, key| hash[key] = [] }

      def attributes
        @@attributes[self]
      end
      
      def attribute(name)
        define_method(name) do
          read_attr(name)
        end

        define_method(:"#{name}=") do |value|
          write_attr(name, value)
        end

        attributes << name unless attributes.include?(name)
      end
      
      # Convenient method for creation of Models.
      def create(attrs)
        raise ArgumentError, "id argument must be provided in hash" unless attrs.has_key? :id
        model = new(attrs)
        model.create
        model
      end
      
      # Convenient method for Model loading.
      def load(id)
        new(:id => id) if id && self.exists?(id)
      end
      
      # Checks if this model instance is already cached.
      def cached?(id)
        puts new(:id => id).redis_key
        redis.exists new(:id => id).redis_key
      end
          
      def model
         self.to_s.split('::').last.downcase
      end
      
      def key
        Nest.new(model, redis)
      end
            
      def exists?(id)
         all.sismember(id)
      end
       
      def all
        key[:all]
      end
      
      def redis_key(id)
        raise ArgumentError, "id argument is not set" if id.nil?
        "#{model}:#{id}"
      end
      
      # Gets the single redis instance
      def redis
        SocialStream::Backend.redis
      end
    end
    

  end
end