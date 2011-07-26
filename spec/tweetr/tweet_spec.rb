require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SocialStream::Tweetr::Tweet do

  describe "creation" do
    before(:each) do
      @tweet_data = Hashie::Mash.new(:text => "example tweet" , :user => {:screen_name => "mixomat" } )
    end
    
    it "can be created with data" do
      tweet = SocialStream::Tweetr::Tweet.create 1, @tweet_data
      
      tweet.id.should_not be_nil
      tweet.text.should === "example tweet"
      tweet.author.should === "mixomat"
    end
    
    it "can show a nice string representation" do
      tweet = SocialStream::Tweetr::Tweet.create 1, @tweet_data
      
      tweet.to_s.should =~ /\d+: example tweet \(mixomat\)/
    end
  end
  
  describe "loading" do
    it "can be loaded for an id" do
      tweet = SocialStream::Tweetr::Tweet.load 1
      
      tweet.should_not be_nil
      tweet.id.should === 1
    end
  end

end