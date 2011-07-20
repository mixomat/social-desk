$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require "twitter_stream"
require "rubygems"
require "bundler"
require "sinatra"
require "rspec"
require "rack/test"

set :environment, :test
 
RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end