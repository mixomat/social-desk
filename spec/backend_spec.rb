require File.dirname(__FILE__) + '/spec_helper'


describe SocialStream::Backend do
    
  it "can retrieve the current redis instance" do
    redis = SocialStream::Backend.redis
    
    redis.client.host.should === "127.0.0.1"
    redis.client.port.should === 6379
  end
  
  context "when included as module" do
    
    module DummyModule
      class Dummy
        include SocialStream::Backend
        attribute :foo
        attribute :bar
      end
    end
    
    before(:each) do
      @dummy = DummyModule::Dummy.new(:id => 1)
      @klass = DummyModule::Dummy
    end
    
    it "can get the model namespace" do
      @dummy.model.should === "dummy"
    end

    it "can get a next id" do
      @dummy.next_id.should_not be_nil
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
      it "can be loaded for an id" do
        dummy = @klass.load 1
        dummy.should_not be_nil
        dummy.foo.should === "john"
        dummy.bar.should === "doe"
      end
    end
     
  end
  
  
end