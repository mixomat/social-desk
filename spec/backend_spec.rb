require File.dirname(__FILE__) + '/spec_helper'


describe SocialStream::Backend do
    
  it "can retrieve the current redis instance" do
    redis = SocialStream::Backend.redis
    
    redis.client.host.should === "127.0.0.1"
    redis.client.port.should === 6379
  end
  
  context "when included as module" do
    
    module DummyModule
      class Item
        include SocialStream::Backend
        attribute :baz
      end
      
      class Dummy
        include SocialStream::Backend
        attribute :foo
        attribute :bar
        
        collection :items, Item
      end


    end
    
    before(:each) do
      @dummy = DummyModule::Dummy.create(:id => 1, :foo => "john", :bar => "doe" )
      @klass = DummyModule::Dummy
    end
    
    it "can get the model namespace" do
      @dummy.model.should === "dummy"
    end

    it "can get a redis key" do
      @dummy.key.should === "dummy:1"
    end
    
    it "can get a redis key for an attribute" do
      @dummy.key[:name].should === "dummy:1:name"
    end
    
    it "can get the class model namespace" do
      @klass.model.should === "dummy"
    end
    
    it "can get the redis instance" do
      @klass.redis.should be_kind_of Redis
    end

    context "when :foo and :bar attributes are set" do    
      it "attributes array should have 2 attributes" do
        @klass.attributes.should have(2).thing
        @klass.attributes.first.should === :foo
      end
      
      it "has a getter for :foo" do
        @dummy.respond_to? :foo
      end
      
      it "has a setter for :bar" do
        @dummy.bar = "test"
        @dummy.bar.should === "test"
      end
      
      it "can create a hash" do
        @dummy.to_hash.should === {:foo => "john", :bar => "doe" }
      end
      

      
      context "on creation" do
        it "can be instantiated with attributes hash" do
          klas = @klass.new(:id => 1, :foo => "john", :bar => "doe" )
        end

        it "can be created with attributes hash" do
          @klass.create(:id => 1, :foo => "john", :bar => "doe" )
        end

        it "exists after creation" do
          @klass.exists?(1).should be_true
        end
      end

      context "on loading" do
        
        before(:each) do
          @loaded = DummyModule::Dummy.load(1)
        end
        
        it "can be loaded for an id" do
          @loaded.should_not be_nil
          @loaded.foo.should === "john"
          @loaded.bar.should === "doe"
        end
        
        it "can create a hash when loaded" do
          @loaded.to_hash.should === {:foo => "john", :bar => "doe"}
        end
      end
    end
    
    context ":items collection is set" do
      it "can get the items collection" do
        @dummy.items.should be_kind_of SocialStream::Backend::Collection 
      end
      
      it "can add a collection member" do
        @dummy.items << DummyModule::Item.create(:id => 1, :baz => "nix")
      end      
    end
     
  end
  
  describe SocialStream::Backend::Collection do

    before(:each) do
      @dummy = DummyModule::Dummy.create(:id => 1)
      @collection = SocialStream::Backend::Collection.new @dummy.key[:items], DummyModule::Item
      @item = DummyModule::Item.load(1)
    end
    
    it "has a key and model accessor" do
      @collection.key.should === "dummy:1:items"
      @collection.model.name.should === "DummyModule::Item"
    end
    
    it "allows adding of models" do
      @collection << @item
    end
    
    it "can check if a model is in this collection" do
      @collection << @item
      @collection.include?(@item).should be_true
    end
    
    it "can iterate over each model" do
      @collection << @item
      @collection.each do |model|
        model.baz.should === "nix"
      end
    end
    
    it "can serialize to a nice json string" do
      @collection.to_json.should === "[{\"baz\":\"nix\"}]"
    end
    
    it "can be cleared" do
      @collection << @item
      @collection.clear
    end
    
    it "has an empty status of false if it contains an item" do
      @collection << @item
      @collection.empty?.should be_false
    end
    
    it "has an empty status of true if it is empty" do
      @collection.clear
      @collection.empty?.should be_true
    end
  end
  
end