require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe SocialStream::Tweetr::Lists do
  
   before(:each) do
     @tweetr = SocialStream::Tweetr.new "mixomat"
   end
   
   it "can get current lists for tweetr user" do
     lists = @tweetr.lists
     
     lists.should be_kind_of Array
     lists.should have_at_least(1).things
     lists.first[:name].should === "Games"
   end

   describe SocialStream::Tweetr::Lists::Loader do
     
     it "can update the users lists from twitter" do
       lists = SocialStream::Tweetr::Lists::Loader.update  @tweetr.client
       lists.first.should be_kind_of Hashie::Mash
     end

     it "can retrieve cached lists for user " do
       lists = SocialStream::Tweetr::Lists::Loader.load

       lists.should be_kind_of Array
       lists.should have_at_least(1).things
       lists.first[:name].should === "Games"
     end

     it "can check the cached status" do
       cached = SocialStream::Tweetr::Lists::Loader.cached?

       cached.should be_true
     end
     
   end


 end