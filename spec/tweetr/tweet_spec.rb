require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SocialStream::Tweetr::Tweet do

  describe "creation" do
    before(:each) do
      @tweet_data = {:id => 1, :text => "example tweet" , :author => "mixomat"}
      @tweet = SocialStream::Tweetr::Tweet.create @tweet_data
    end
    
    it "can be created with data" do
      @tweet.id.should === "1"
      @tweet.text.should === "example tweet"
      @tweet.author.should === "mixomat"
    end
    
    it "can show a nice string representation" do
      @tweet.to_s.should =~ /\d+: example tweet \(mixomat\)/
    end
    
    it "can show a nice json representation" do
      @tweet.to_json.should === "{\"author\":\"mixomat\",\"text\":\"example tweet\",\"id\":\"1\"}"
    end
  end
  
  describe "loading" do
    before(:each) do
      @tweet = SocialStream::Tweetr::Tweet.load 1
    end
    
    it "can be loaded for an id" do
      @tweet.id.should === "1"
    end
    
    it "can show a nice json representation" do
      @tweet.to_json.should === "{\"author\":\"mixomat\",\"text\":\"example tweet\",\"id\":\"1\"}"
    end
  end

end