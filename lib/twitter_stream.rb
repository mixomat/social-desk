require "rubygems"
require "bundler"
require "redis"

module TwitterStream

end

root = File.expand_path(File.dirname(__FILE__))
require "#{root}/twitter_stream/connection"
require "#{root}/twitter_stream/lists"

