require 'test_helper'

class EApiClientTest < ActiveSupport::TestCase

  test "check endpoint" do
  	p "Verifying if configuration loads correctly"
    assert_match "localhost:3003", EApiClient::ActiveClient::JSON::Base.global_base_url
  end

end
