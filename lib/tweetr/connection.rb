require "rubygems"
require "bundler"
require "twitter"

module SocialStream
  class Tweetr
    module Connection

      Twitter.configure do |config|
        config.consumer_key = "ykRlmiNqGEDDqbm6GomScA"
        config.consumer_secret = "FPqsMCzo7DLSyYNJanhKO3tJTbL6kAwfpmVGVXU"
        config.oauth_token = "105779972-QUdrMDMXHpKepge93wicXX4t0ZtVbuAKmRib6HqR"
        config.oauth_token_secret = "JF385oyZhTuPbqxNeTGwqiKHBIuyi1W6EpgxFzf7uLE"
      end
  
      def connect
        Twitter::Client.new
      end

    end
  end
end