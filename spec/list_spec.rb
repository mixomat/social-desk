require File.dirname(__FILE__) + '/spec_helper'

describe TwitterStream::Lists do
    
  before(:each) do
    @twitter_lists = TwitterStream::Lists.new("mixomat")
  end
  
  it "can instantiate with user" do
    lists = TwitterStream::Lists.new("mixomat")
    
    lists.user.should === "mixomat"
  end
  
  it "can update the users lists from twitter" do
    lists = @twitter_lists.update
    
    lists.first.should be_kind_of Hashie::Mash
  end
  
  it "can retrieve cached lists for user " do
    lists = @twitter_lists.load

    lists.should be_kind_of Array
    lists.should have_at_least(1).things
    lists.first[:name].should === "Games"
  end
  
  it "can get the timeline for a list" do
    list = @twitter_lists.lists.first
    timeline = @twitter_lists.timeline list
    
    timeline.should have_at_least(20).thing
    timeline.first.should be_kind_of Hashie::Mash
    timeline.first.text.should have_at_least(2).characters
  end
  

end