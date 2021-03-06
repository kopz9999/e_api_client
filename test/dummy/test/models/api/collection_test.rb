require 'test_helper'

class Api::CollectionTest < Api::BaseTest

  def setup
    super
    10.times.each { Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: Random.new.rand( 100 ) ) }    
  end

  test ".all" do
    items = Api::Item.all

    assert_kind_of Array, items
    assert_equal items.length, 10
    assert_kind_of Api::Item, items.first
  end

  test ".page" do
    ordered_items = Api::Item.order id: "asc"
    items = Api::Item.order(id: "asc").page(2).per(3)

    assert_equal items.length, 3
    assert_equal items.first.id, ordered_items[3].id
  end

  test ".order" do
    unordered_items = Api::Item.all
    ordered_items = Api::Item.order(id: "asc")

    unordered_items.sort! { |a,b| a.id <=> b.id }

    assert_equal ordered_items.length, unordered_items.length
    assert_equal ordered_items.first.id, unordered_items.first.id
    assert_equal ordered_items.last.id, unordered_items.last.id
  end

  test ".where" do
    items = Api::Item.all
    filtered_items = Api::Item.order(id: "desc").where(id: items.first.id )

    assert_equal filtered_items.length, 1
    assert_equal filtered_items.first.id, items.first.id
  end

  test ".remote_query" do
    searched_quantity = 40
    filtered_items = Api::Item.all.select{ |it| it.quantity > searched_quantity }
    remote_query = Api::Item.remote_query(resource: 'items/custom_resource', params: { quantity: searched_quantity }).remote_fetch

    assert_equal filtered_items.length, remote_query.length
  end

  test ".create" do
    item = Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: 23.2 )
    assert_kind_of Integer, item.id
    assert_kind_of Api::Item, item
  end

  test ".find" do
    item = Api::Item.create( name: "Item #{ Time.now.to_i }", quantity: 23.2 )
    item2 = Api::Item.find item.id
    assert item.id == item2.id
    assert item.name == item2.name
    assert item.quantity == item2.quantity
    assert_kind_of Api::Item, item
    assert_kind_of Api::Item, item2
  end

  test ".each" do
    i = 0
    items = Api::Item.order(id: "asc").page(2).per(3)
    items.each do | it |
      i += 1
    end
    assert_equal items.length, i
  end

end
