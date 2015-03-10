class Api::Item

	include EApiClient::ActiveClient::JSON::Activable

	model_resources "items"

	api_attr_accessor :id, :id
	api_attr_accessor :name, :name
	api_attr_accessor :quantity, :quantity	
  api_attr_accessor :created_at, :created_at, EApiClient::ActiveClient::JSON::DataParser::DateTime

  after_update :on_after_update
  after_save :on_after_save
  after_destroy :on_after_destroy
  after_create :on_after_create

  before_update :on_before_update
  before_save :on_before_save
  before_destroy :on_before_destroy
  before_create :on_before_create

  request_element :item

  attr_accessor :message

  #After callbacks

  def on_after_update
    self.message = "on_after_update"    
  end

  def on_after_save
    self.message = "on_after_save"    
  end

  def on_after_destroy
    self.message = "on_after_destroy"    
  end

  def on_after_create
    self.message = "on_after_create"    
  end

  #Before callbacks

  def on_before_update
    self.message = "on_before_update"    
  end

  def on_before_save
    self.message = "on_before_save"    
  end

  def on_before_destroy
    self.message = "on_before_destroy"    
  end

  def on_before_create
    self.message = "on_before_create"    
  end

end
