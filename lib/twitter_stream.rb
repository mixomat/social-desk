require "rubygems"
require "bundler"
require "twitter"

class TwitterStream
  attr_reader :twitter
  
  def initialize
    # initialize twitter oauth config
    Twitter.configure do |config|
      config.consumer_key = "ykRlmiNqGEDDqbm6GomScA"
      config.consumer_secret = "FPqsMCzo7DLSyYNJanhKO3tJTbL6kAwfpmVGVXU"
      config.oauth_token = "105779972-QUdrMDMXHpKepge93wicXX4t0ZtVbuAKmRib6HqR"
      config.oauth_token_secret = "JF385oyZhTuPbqxNeTGwqiKHBIuyi1W6EpgxFzf7uLE"
    end
    
    @twitter = Twitter::Client.new
  end
  
  def lists
    @twitter.lists.lists.each do |list|
      (twitter_lists ||= []) << TwitterList.new(list.id, list.slug, list.name)
    end
  end
  
  def list_timeline(twitter_list)
    @twitter.list_timeline twitter_list.id
  end
  
end

class TwitterList
  attr_accessor :id, :slug, :name
  
  def initialize(id, slug, name)
    @id = id
    @slug = slug
    @name = name
  end
  
  def to_s
    "#{id}, #{name}"
  end
end