require 'e_api_client/active_client/json'

module EApiClient
	module ActiveClient
		
		module RequestMethods
			GET = 0
			POST = 1
			PUT = 2
			DELETE = 3
		end

		module StatusCodes
			Ok = 200
			Created = 201
			NoContent = 204
			BadRequest = 400
			UnprocessableEntity = 422
		end
		
	end
end
