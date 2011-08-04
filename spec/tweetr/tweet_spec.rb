require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SocialStream::Tweetr::Tweet do

  describe "creation" do
    before(:each) do
      @tweet_data = {:id => 1, :text => "example tweet" , :author_name => "mixomat", :author_avatar => "http://example.com/avatar"}
      @tweet = SocialStream::Tweetr::Tweet.create @tweet_data
    end
    
    it "can be created with data" do
      @tweet.id.should === "1"
      @tweet.text.should === "example tweet"
      @tweet.author_avatar.should === "http://example.com/avatar"
      @tweet.author_name.should === "mixomat"
    end
    
    it "can show a nice json representation" do
      @tweet.to_json.should === "{\"author\":{\"avatar\":\"http://example.com/avatar\",\"name\":\"mixomat\"},\"text\":\"example tweet\",\"id\":\"1\"}"
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
      @tweet.to_json.should === "{\"author\":{\"avatar\":\"http://example.com/avatar\",\"name\":\"mixomat\"},\"text\":\"example tweet\",\"id\":\"1\"}"
    end
  end

end