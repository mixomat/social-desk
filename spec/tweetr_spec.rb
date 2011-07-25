require File.dirname(__FILE__) + '/spec_helper'

describe SocialStream::Tweetr do
    
    before(:each) do
      @tweetr = SocialStream::Tweetr.new("mixomat")
    end
    
    describe "initialization" do
      it "can init with screen_name" do
        @tweetr = SocialStream::Tweetr.new "mixomat"
        
        @tweetr.user.should === "mixomat"
      end
    end

    describe "list timeline" do
      it "can get the timeline for a list" do
        list = @tweetr.lists.first
        timeline = @tweetr.list_timeline list

        timeline.id.should_not be_nil
        timeline.tweets.should have_at_least(20).thing

        tweet = timeline.tweets.first
        tweet.should be_kind_of SocialStream::Tweetr::Tweet
        tweet.id.should_not be_nil
        tweet.text.should have_at_least(2).characters
        tweet.author.should have_at_least(2).character
      end
    end

end