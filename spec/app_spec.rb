require File.dirname(__FILE__) + '/spec_helper'

describe 'Social Desk app' do

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    last_response.should be_ok
  end
end