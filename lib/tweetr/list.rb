class List
  include SocialStream::Backend
  
  attribute :name
  
  def to_json(*args)
    { :id => id, :name => name }.to_json(*args)
  end
end