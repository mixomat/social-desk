require File.expand_path(File.join(File.dirname(__FILE__), '/spec_helper'))

describe 'Social Desk app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    last_response.should be_ok
  end
end