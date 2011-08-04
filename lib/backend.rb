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
            
      def initialize(attrs = {})
        @id = initialize_id(attrs[:id])
        @attrs = Hash.new { |hash, key| hash[key] = load_attr(key) }
        update_attributes(attrs.reject{|k,v| k === :id})
      end
      
      def initialize_id(id)
        @id = id.to_s
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
        redis.hget key, name
      end
      
      def store_attr(name, value)
        write_attr(name, value)
        redis.hset key, name, value
      end

      def model
        self.class.model
      end
      
      def key
        self.class.key[id]
      end

      def to_hash
        attrs = {}
        self.class.attributes.each do |name|
          attrs[name] = read_attr(name)
        end
        attrs
      end
      
      def to_s
        "#{@id}: #{@attrs}"
      end
    end
    
    module ClassMethods
  
      # Attributes, collections class variables, which contain an array of attributes, collections for each class.  
      #
      @@attributes  = Hash.new { |hash, key| hash[key] = [] }
      @@collections  = Hash.new { |hash, key| hash[key] = [] }
      
      def attributes
        @@attributes[self]
      end
      
      def collections
        @@collections[self]
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
      
      def collection(name, model)
        define_method(name) do
          Collection.new(key[name], model)
        end
        
        collections << name unless collections.include?(name)
      end
      
      # Convenient method for creation of Models.
      def create(attrs)
        raise ArgumentError, "id argument must be provided in hash" unless attrs.has_key? :id
        model = new(attrs)
        model.store
        model
      end
      
      # Convenient method for Model loading.
      def load(id)
        new(:id => id) if id && self.exists?(id)
      end
      alias [] load
       
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
      
      # Gets the single redis instance
      def redis
        SocialStream::Backend.redis
      end
    end
    
    class Collection
      attr_accessor :key, :model
      
      def initialize(key, model)
        @key = key
        @model = model
      end
      
      # Adds a model to this set.
      def <<(model)
        key.sadd(model.id)
      end
      alias add <<
      
      def include?(model)
        key.sismember(model.id)
      end
      
      def each(&block)
        key.smembers.each {|id| block.call(model.load(id)) }
      end
      
      def inject(result, &block)
        key.smembers.each {|id| block.call(result, model.load(id)) }
        result
      end
      
      def first
        model.load(key.smembers.first)
      end
      
      # Deletes this collection.
      def clear
        key.del
      end
      
      # Checks if the collection is empty.
      def empty?
        !key.exists
      end
    
      def to_json(*args)
        result = []
        each { |model| result << model}
        result.to_json(*args)
      end
      
      def to_s
        key.smembers
      end
    end
    

  end
end