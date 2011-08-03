require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe SocialStream::Tweetr::Timeline do

  before(:each) do
    @timeline_id = 1
  end

  describe "creation" do
    before(:each) do
      @timeline_data = {:id => 1, :text => "example tweet" , :user => {:screen_name => "mixomat" }}
      @timeline_mash =  [Hashie::Mash.new(@timeline_data)]
      @timeline = SocialStream::Tweetr::Timeline.create_from_data @timeline_id, @timeline_mash
    end
    
    
    it "can be created with data from twitter" do
      @timeline.should be_kind_of SocialStream::Tweetr::Timeline
      @timeline.id.should_not be_nil
      @timeline.tweets.should_not be_nil
    end
    
    it "should have tweets" do
      @timeline.tweets.first.text.should === "example tweet"
    end
    
    it "can serialize to json" do
      @timeline.to_json.should =~ /\{"tweets":\[\{"author":"mixomat","text":"example tweet","id":"1"\}\],"id":"1"\}/
    end
  end
  
  describe "loading" do
    
    before(:each) do
      @loaded =  SocialStream::Tweetr::Timeline.load(@timeline_id)
    end
    
    it "can be loaded with an id" do
      @loaded.id.should_not be_nil
    end
    
    it "contains tweets" do
      tweet = @loaded.tweets.first
       
      tweet.should be_kind_of SocialStream::Tweetr::Tweet
      tweet.text.should === "example tweet"
    end
    
    it "can serialize to json" do
      @loaded.to_json.should =~ /\{"tweets":\[\{"author":"mixomat","text":"example tweet","id":"1"\}\],"id":"1"\}/
    end
  end
  
  
end
