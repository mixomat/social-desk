require File.dirname(__FILE__) + '/spec_helper'

describe TwitterStream::Lists do
    
  before(:each) do
    @twitter_lists = TwitterStream::Lists.new("mixomat")
  end
  
  it "can instantiate with user" do
    lists = TwitterStream::Lists.new("mixomat")
  end
  
  it "can retrieve lists for user " do
    lists = @twitter_lists.lists
    
    lists.should be_kind_of Array
    lists.should have_at_least(1).things
    lists.first[:name].should === "Games"
  end
  
  it "can get the timeline for a list" do
    list = @twitter_lists.lists.first
    timeline = @twitter_lists.timeline list
    
    timeline.first.should be_kind_of Hashie::Mash
  end
  

end