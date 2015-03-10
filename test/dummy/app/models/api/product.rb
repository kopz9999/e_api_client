class Api::Product

  include EApiClient::ActiveClient::JSON::Activable

  model_resources "products"

  api_attr_accessor :id, :id
  api_attr_accessor :name, :name  
  api_attr_accessor :description, :description

end
