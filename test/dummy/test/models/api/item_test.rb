require 'test_helper'

class Api::ItemTest < ActiveSupport::TestCase

  test "select" do
    p "TEST SELECT"

  	items = Api::Item.select
  	p "Receiving:"
  	p items.inspect
  	assert_kind_of Array, items
  end

  test "create" do
    p "TEST CREATE"

  	item = Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: 23.2 )

  	p "Created: "
  	p item.inspect  	

  	assert_kind_of Integer, item.id
  	assert_kind_of Api::Item, item
  end

  test "update" do
    p "TEST UPDATE"

  	name_to_update = "Item Updated - #{ Time.now.to_i }"
  	item = Api::Item.create( name: "Item 2", quantity: 23.2 )
  	created_id = item.id

  	p "Created: "
  	p item.inspect  	

  	item.update( { name: name_to_update }, { set_by_response: true } ) 

  	p "Updated: "
  	p item.inspect  	

  	assert_kind_of Integer, item.id
  	assert_match name_to_update, item.name
  	assert created_id == item.id
  	assert_kind_of Api::Item, item
  end

  test "save" do
    p "TEST SAVE"

  	name_to_save = "Item Saved - #{ Time.now.to_i }"
  	item = Api::Item.create( name: "Item 3", quantity: 23.2 )
  	created_id = item.id

  	p "Created: "
  	p item.inspect

  	item.name = name_to_save
  	item.quantity = 500
  	item.save set_by_response: true 

  	p "Saved: "
  	p item.inspect  	

  	assert_kind_of Integer, item.id
  	assert_match name_to_save, item.name
  	assert created_id == item.id
  	assert_kind_of Api::Item, item
  end

  test "find" do
    p "TEST FIND"

  	item = Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: 23.2 )

  	p "Created: "
  	p item.inspect

  	item2 = Api::Item.find item.id

  	p "Found: "
  	p item2.inspect  	

  	assert item.id == item2.id
  	assert item.name == item2.name
  	assert item.quantity == item2.quantity
  	assert_kind_of Api::Item, item
  	assert_kind_of Api::Item, item2
  end

  test "destroy" do
    p "TEST DESTROY"

  	item = Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: 23.2 )

  	p "Created: "
  	p item.inspect

  	item.destroy
  	p "Destroyed: "
  	p item.inspect

  	item2 = Api::Item.find item.id

  	assert item2.nil?
  end

end
