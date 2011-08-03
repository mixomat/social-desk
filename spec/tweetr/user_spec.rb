require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SocialStream::Tweetr::User do
  before(:each) do
    @user = SocialStream::Tweetr::User.create(:id => "dummy_user")
  end

  context "initialization" do
    it "has an id" do
      @user.id.should === "dummy_user"
    end
  end
  
  context "update_lists" do
    before(:each) do
      @user.update_lists [Hashie::Mash.new(:id => "1", :name => "Games"), Hashie::Mash.new(:id => "2", :name => "Geeks")]
    end

    it "first item in updated list should be Games" do
      @user.lists.first.name.should === "Games"
    end
    
    it "contains the lists in json" do
      @user.to_json.should =~ /"lists":\[\{"name":"Games","id":"1"\},\{"name":"Geeks","id":"2"\}\]/
    end
  end
  
  
end