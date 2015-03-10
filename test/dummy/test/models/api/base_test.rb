require 'test_helper'

class Api::BaseTest < ActiveSupport::TestCase

  test "all" do
    items = Api::Item.all
    products = Api::Product.all
    binding.pry
    assert_kind_of Array, items
    assert_kind_of Array, products
  end

end
