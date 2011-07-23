require File.dirname(__FILE__) + '/spec_helper'

describe SocialStream::Tweetr do
    
  before(:each) do
    @tweetr_lists = SocialStream::Tweetr::Lists.new("mixomat")
  end
  
  it "can instantiate with user" do
    lists = SocialStream::Tweetr::Lists.new("mixomat")
    
    lists.user.should === "mixomat"
  end
  
  it "can update the users lists from twitter" do
    lists = @tweetr_lists.update
    
    lists.first.should be_kind_of Hashie::Mash
  end
  
  it "can retrieve cached lists for user " do
    lists = @tweetr_lists.load

    lists.should be_kind_of Array
    lists.should have_at_least(1).things
    lists.first[:name].should === "Games"
  end
  
  it "can check the cached status" do
    cached = @tweetr_lists.cached?
    
    cached.should be_true
  end
  
  it "can get the timeline for a list" do
    list = @tweetr_lists.lists.first
    timeline = @tweetr_lists.timeline list
    
    timeline.should have_at_least(20).thing
    timeline.first.should be_kind_of Hashie::Mash
    timeline.first.text.should have_at_least(2).characters
  end
  

end