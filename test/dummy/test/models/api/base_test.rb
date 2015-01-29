require 'test_helper'

class Api::BaseTest < ActiveSupport::TestCase

  test "select" do
    items = Api::Item.select
    products = Api::Product.select
    assert_kind_of Array, items
    assert_kind_of Array, products
  end

end
