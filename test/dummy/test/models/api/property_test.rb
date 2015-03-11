require 'test_helper'

class Api::PropertyTest < Api::BaseTest

  test "time parser" do
    item = Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: 23.2 )
    assert_kind_of Integer, item.id
    assert_kind_of DateTime, item.created_at
    assert item.created_at_s.to_datetime == item.created_at
    assert_kind_of Api::Item, item
  end

end
