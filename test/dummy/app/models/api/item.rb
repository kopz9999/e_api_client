class Api::Item

  extend ActiveModel::Callbacks
	include EApiClient::ActiveClient::JSON::Pluggable

	model_resources "items"

	model_request_single_name :item

	api_attr_accessor :id, :id
	api_attr_accessor :name, :name	
	api_attr_accessor :quantity, :quantity	

  after_update :on_after_update
  after_save :on_after_save
  after_destroy :on_after_destroy
  after_create :on_after_create

  before_update :on_before_update
  before_save :on_before_save
  before_destroy :on_before_destroy
  before_create :on_before_create

  #After callbacks

  def on_after_update
    puts "on_after_update"    
  end

  def on_after_save
    puts "on_after_save"    
  end

  def on_after_destroy
    puts "on_after_destroy"    
  end

  def on_after_create
    puts "on_after_create"    
  end

  #Before callbacks

  def on_before_update
    puts "on_before_update"    
  end

  def on_before_save
    puts "on_before_save"    
  end

  def on_before_destroy
    puts "on_before_destroy"    
  end

  def on_before_create
    puts "on_before_create"    
  end

end
