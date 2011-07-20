require File.dirname(__FILE__) + '/spec_helper'

describe TwitterStream do
    
  before(:each) do
    @twitter_stream = TwitterStream.new
  end
  
  it "can instantiate without args" do
    stream = TwitterStream.new
    stream.twitter.should be_kind_of Twitter::Client
  end
  
  it "can retrieve lists for screen_name " do
    lists = @twitter_stream.lists
    
    lists.should be_kind_of Array
    lists.should have_at_least(1).things
    lists.first.name.should === "Games"
    lists.first.slug.should === "games"
  end
  
  it "can get the timeline for a given list" do
    list = @twitter_stream.lists.first
    timeline = @twitter_stream.list_timeline list
    
    puts timeline
    
  end
  

end