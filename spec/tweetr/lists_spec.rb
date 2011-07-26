require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))


describe SocialStream::Tweetr::Lists do
  
  before(:each) do
    @list_data = [Hashie::Mash.new(:id => 1 , :name => "Games")]
  end

  it "can be created with data" do
    lists = SocialStream::Tweetr::Lists.create 1, @list_data
    
    lists.should be_kind_of SocialStream::Tweetr::Lists
    lists.items.should have(1).things
    
    list = lists.items.first
    list.should be_kind_of SocialStream::Tweetr::List
    list.name.should === "Games"  
    list.id.should === 1      
  end
  
  
  it "can check the cached status" do
    cached = SocialStream::Tweetr::Lists.cached? 1
    cached.should be_true
  end
end
