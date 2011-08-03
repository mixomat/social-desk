require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))


describe SocialStream::Tweetr::Lists do
  
  before(:each) do
    list_data = [Hashie::Mash.new(:id => 1 , :name => "Games")]
    @lists = SocialStream::Tweetr::Lists.create_from_data 1, list_data
  end

  it "can be created with data" do
    @lists.should be_kind_of SocialStream::Tweetr::Lists
    
    list = @lists.items.first
    list.should be_kind_of List
    list.name.should === "Games"  
    list.id.should === "1"      
  end
  
  
  it "can check the cached status" do
    cached = SocialStream::Tweetr::Lists.exists? 1
    cached.should be_true
  end
  
  it "can serialize to json" do
    @lists.to_json.should =~ /"items":\[\{"name":"Games","id":"1"\}\],"id":"1"\}/
  end
end
