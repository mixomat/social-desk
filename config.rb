$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require "backend"
require "tweetr"

set :public, File.dirname(__FILE__) + '/public'

configure do
  # initialize twitter stream
  @@tweetr = SocialStream::Tweetr.new "mixomat"
end