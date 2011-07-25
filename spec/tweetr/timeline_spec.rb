require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe SocialStream::Tweetr::Timeline do
  
  before(:each) do
    @tweetr = SocialStream::Tweetr.new("mixomat")
  end
  
  describe "Timeline" do
    it "can be loaded with an id" do
      list = @tweetr.lists.first
      timeline =  SocialStream::Tweetr::Timeline.load(list[:id])

      timeline.id.should_not be_nil
      timeline.tweets.should have_at_least(20).thing
            
      tweet = timeline.tweets.first
      
      tweet.should be_kind_of SocialStream::Tweetr::Tweet
      tweet.text.should have_at_least(2).characters
    end
    
    it "can be created with data" do
      timeline_data = [Hashie::Mash.new(:text => "example tweet" , :user => {:screen_name => "mixomat" })]
      timeline = SocialStream::Tweetr::Timeline.create 1, timeline_data
      
      timeline.should be_kind_of SocialStream::Tweetr::Timeline
      timeline.id.should_not be_nil
    end
  end
  
  describe "Tweet" do
    before(:each) do
      @tweet_data = Hashie::Mash.new(:text => "example tweet" , :user => {:screen_name => "mixomat" } )
    end
    
    it "can be created with data" do
      tweet = SocialStream::Tweetr::Tweet.create @tweet_data
      
      tweet.id.should_not be_nil
      tweet.text.should === "example tweet"
      tweet.author.should === "mixomat"
    end
    
    it "can show a nice string representation" do
      tweet = SocialStream::Tweetr::Tweet.create @tweet_data
      
      tweet.to_s.should =~ /\d+: example tweet \(mixomat\)/
    end
  end
  
end
