require File.dirname(__FILE__) + '/spec_helper'


describe SocialStream::Backend do
    
  it "can retrieve the current redis instance" do
    redis = SocialStream::Backend.redis
    
    redis.client.host.should === "127.0.0.1"
    redis.client.port.should === 6379
  end
  
  context "when included" do
    
    module DummyModule
      class Dummy
        include SocialStream::Backend

        def initialize
          @id = 1
        end
      end
    end
    
    it "can get the model namespace" do
      model = DummyModule::Dummy.new.model
      model.to_s.should === "dummy"
    end
    
    it "can get the class model namespace" do
      DummyModule::Dummy.model.to_s.should === "dummy"
    end
    
    it "can get a next id" do
      id = DummyModule::Dummy.new.next_id
      id.should_not be_nil
    end
    
    it "can get a redis key" do
      key = DummyModule::Dummy.new.redis_key
      key.should  === "dummy:1"
    end
    
    it "can get a redis key for an attribute" do
      key = DummyModule::Dummy.new.redis_attr_key :name
      key.should === "dummy:1:name"
    end
    
    it "can get the redis instance" do
      redis = DummyModule::Dummy.redis
      redis.should be_kind_of Redis
    end
  end

  
  
  
end