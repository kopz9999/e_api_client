require 'test_helper'

class Api::ErrorTest < ActiveSupport::TestCase

  test "server error" do
    ex = nil
    begin
      Api::Item.remote_query(resource: 'items/error_test' ).remote_fetch
    rescue EApiClient::ServerError => err
      ex = err
    end

    assert_kind_of EApiClient::ServerError, ex
  end

end