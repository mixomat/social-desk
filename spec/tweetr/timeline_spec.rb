require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe SocialStream::Tweetr::Timeline do
  
  before(:each) do
    @timeline_id = 1
    @timeline_data = [Hashie::Mash.new(:id_str => 1, :text => "example tweet" , :user => {:screen_name => "mixomat" })]
  end
  
  describe "creation" do
    it "can be created with data" do
      timeline = SocialStream::Tweetr::Timeline.create @timeline_id, @timeline_data
      
      timeline.should be_kind_of SocialStream::Tweetr::Timeline
      timeline.id.should_not be_nil
    end
    
    it "can serialize to json" do
      timeline = SocialStream::Tweetr::Timeline.create @timeline_id, @timeline_data
      
      timeline.to_json.should =~ /\{"tweets":\[\{"author":"mixomat"/
    end
  end
  
  describe "loading" do
    it "can be loaded with an id" do
      timeline =  SocialStream::Tweetr::Timeline.load(@timeline_id)

      timeline.id.should_not be_nil
      timeline.tweets.should have_at_least(1).thing
            
      tweet = timeline.tweets.first
      
      tweet.should be_kind_of SocialStream::Tweetr::Tweet
      tweet.text.should have_at_least(2).characters
    end
  end
  
  
end
