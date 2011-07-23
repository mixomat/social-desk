require File.dirname(__FILE__) + '/lib/tweetr'

set :public, File.dirname(__FILE__) + '/public'

configure do
  # initialize twitter stream
  @@tweetr = SocialStream::Tweetr::Lists.new "mixomat"
end
