require 'test_helper'

class Api::ItemTest < ActiveSupport::TestCase

  test "create" do
    item = Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: 23.2 )
    assert_kind_of Integer, item.id
    assert_kind_of Api::Item, item
  end

  test "update" do
    name_to_update = "Item Updated - #{ Time.now.to_i }"
    item = Api::Item.create( name: "Item 2", quantity: 23.2 )
    created_id = item.id
    item.update( { name: name_to_update }, { set_by_response: true } ) 
    assert_kind_of Integer, item.id
    assert_match name_to_update, item.name
    assert created_id == item.id
    assert_kind_of Api::Item, item
  end

  test "save" do
    name_to_save = "Item Saved - #{ Time.now.to_i }"
    item = Api::Item.create( name: "Item 3", quantity: 23.2 )
    created_id = item.id
    item.name = name_to_save
    item.quantity = 500
    item.save set_by_response: true 
    assert_kind_of Integer, item.id
    assert_match name_to_save, item.name
    assert created_id == item.id
    assert_kind_of Api::Item, item
  end

  test "find" do
    item = Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: 23.2 )
    item2 = Api::Item.find item.id
    assert item.id == item2.id
    assert item.name == item2.name
    assert item.quantity == item2.quantity
    assert_kind_of Api::Item, item
    assert_kind_of Api::Item, item2
  end

  test "destroy" do
    item = Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: 23.2 )
    item.destroy
    item2 = Api::Item.find item.id
    assert item2.nil?
  end

end
