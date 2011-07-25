$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require "tweetr"
require "backend"

require "rubygems"
require "bundler"
require "sinatra"
require "rspec"
require "rack/test"
require "hashie"


set :environment, :test
 
RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end