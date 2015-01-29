class Api::Product

  include EApiClient::ActiveClient::JSON::Pluggable

  model_resources "products"

  model_request_single_name :product

  api_attr_accessor :id, :id
  api_attr_accessor :name, :name  
  api_attr_accessor :description, :description

end
