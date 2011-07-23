require "rubygems"
require "bundler"
require "sinatra"
require "rspec"
require "rack/test"

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require "tweetr"

set :environment, :test
 
RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end