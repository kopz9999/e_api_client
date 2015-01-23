require 'e_api_client/active_client/json/client_configurable'
require 'e_api_client/active_client/json/mapped_attribute'
require 'e_api_client/active_client/json/base'

module EApiClient
	module ActiveClient
		module JSON
		
			module RequestMethods
				GET = 0
				POST = 1
				PUT = 2
				DELETE = 3
			end

			module StatusCodes
				UnprocessableEntity = 422
				Ok = 200
				Created = 201
			end

		end		
	end
end
