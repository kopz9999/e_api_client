class Api::Item

	include EApiClient::ActiveClient::JSON::Pluggable

	model_resources "items"

	model_request_single_name :item

	api_attr_accessor :id, :id
	api_attr_accessor :name, :name	
	api_attr_accessor :quantity, :quantity	

end
