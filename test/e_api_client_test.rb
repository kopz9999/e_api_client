require 'test_helper'

class EApiClientTest < ActiveSupport::TestCase

  test "check endpoint" do
    assert_match "localhost:3003", EApiClient::ActiveClient::JSON::Configurable.global_base_url
  end

end
