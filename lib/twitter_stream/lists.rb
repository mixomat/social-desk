require "connection"

module TwitterStream
  class Lists
    include TwitterStream::Connection

    attr_reader :lists
  
    def initialize(user)
      @client ||= connect
      
      # initialize twitter_lists for user
      @lists ||= []
      @client.lists.lists.each do |l|
        @lists << {:id => l.id, :name => l.name}
      end
    end
  
    def timeline(list)
      @client.list_timeline list[:name]
    end

  end
end