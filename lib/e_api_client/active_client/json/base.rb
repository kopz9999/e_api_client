module EApiClient
	module ActiveClient
		module JSON

			class Base

				#Allow client side validations
				include ActiveModel::Validations
				include ClientConfigurable
					
				def self.global_base_url
					@@global_base_url
				end

				def self.global_base_url(global_base_url)
					@@global_base_url = global_base_url
				end		

				def self.api_attr_accessor(local_attribute, remote_attribute)
					current_attr = MappedAttribute.new

					self.class_eval("def #{local_attribute};@#{local_attribute};end")
					self.class_eval("def #{local_attribute}=(val);@#{local_attribute}=val;end")
					#self.attr_accessor local_attribute
					current_attr.local_identifier = local_attribute
					current_attr.remote_identifier = remote_attribute
					self.api_attributes << current_attr
				end

				def self.do_request(url, parameters, request_method)
					default_handler = lambda{|response, request, result| response }
					case request_method 
						when RequestMethods::GET
							result = RestClient.get url, parameters, &default_handler
						when RequestMethods::POST
							result = RestClient.post url, parameters, &default_handler
						when RequestMethods::PUT
							result = RestClient.put url, parameters, &default_handler
						when RequestMethods::DELETE
							result = RestClient.delete url, parameters, &default_handler
					end
					result
				end

				def self.get_json(url, parameters, request_method)
					result = do_request( url, parameters, request_method )					
					Object::JSON.parse(result.to_s, symbolize_names: true)
				end

				#The following methods simulate active record but with REST API

				# Generate an array of this class instances by consuming the service
				# - resource: path of the service
				# - parameters: request parameters
				# - request_method: Enum to get GET, POST, PUT, DELETE
				# - format: url format
				# return [Array]
				def self.select(resource = nil, parameters = {}, request_method = RequestMethods::GET, format = 'json' )
					request_url = self.build_request_url( resource, format )
					self.select!( request_url, parameters, request_method )
				end

				# Generate an array of the service, but it acts in a direct url
				# - request_url (required): url of the service
				# - parameters: request parameters
				# - request_method: Enum to get GET, POST, PUT, DELETE
				# return [Array]
				def self.select!(request_url, parameters = {}, request_method = RequestMethods::GET )
					results = []
					json_response = self.get_json(request_url, parameters, request_method)
					json_results = json_response[ self.get_model_request_plural_name ]
					curr_ptr = nil
					json_results.each do | json_hash |
						curr_ptr = self.instance_by_json( json_hash )
						results << curr_ptr
					end
					results
				end

				# Returns a URL based on configuration
				# return [String]
				def self.build_request_url( resource, format, param_key = nil )
					request_url = self.get_base_url
					if resource.nil?
						request_url += "/#{self.get_model_resources}"
					else
						request_url += "/#{resource}"
					end
					request_url += "/#{param_key}" unless param_key.nil?
					request_url += ".#{format}" unless format.nil?
					return request_url
				end

				# Generate an instance recently created
				# return [Object]
				def self.create(values = {}, options = {}, resource = nil, request_method = RequestMethods::POST, format = 'json')
					request_url = self.build_request_url( resource, format )
					self.create!( request_url, values, options, request_method )
				end

				# Generate an instance recently created, but it acts in a direct url
				# return [Object]
				def self.create!(request_url, values = {}, options = {}, request_method = RequestMethods::POST)
					curr_ptr = self.new( values )
					curr_ptr.save!( request_url, options, request_method )
					return curr_ptr
				end

				# Generates object with the values given from a json
				# return [Object]
				def self.instance_by_json(json_obj = {})
					obj = self.new 
					obj.set_attributes_by_json( json_obj )
					return obj
				end

				# Sets attributes from a Hash object on constructor
				# return [Nil]
				def initialize(values = {})
					set_attributes_by_hash values
				end

				# Sets attributes from a Hash object
				# return [Nil]
				def set_attributes_by_hash(values = {})
					values.each do |key, value|
						meth_key = "#{key}=".to_sym
						self.send(meth_key, value ) if self.respond_to?(meth_key)
					end
				end

				# Sets attributes from a JSON object
				# return [Nil]
				def set_attributes_by_json(json_obj = {})
					self.class.api_attributes.each do |api_attr|
						meth_key = "#{ api_attr.local_identifier }=".to_sym
						remote_value = json_obj[ api_attr.remote_identifier ]
						self.send(meth_key, remote_value )
					end
				end

				# Converts object to rails param hash
				# return [Hash]
				def to_request_object
					result = {}
					request_obj = {}
					self.class.api_attributes.each do |api_attr|
						request_obj[ api_attr.local_identifier ] = self.send( api_attr.local_identifier )
					end
					result[ self.class.get_model_request_single_name ] = request_obj
					return result
				end

				# Saves object to the database
				# return [Boolean]
				def save(options = {}, resource = nil, request_method = RequestMethods::POST, format = 'json')
					assert_validation( options ) do
						request_url = self.class.build_request_url( resource, format ) 
						do_save_request( request_url, request_method )
					end
				end

				# Saves object to the database
				# return [Boolean]
				def save!(request_url, options = {}, request_method = RequestMethods::POST)
					assert_validation( options ) do
						do_save_request( request_url, request_method )
					end
				end

				# Updates object in the database
				# return [Boolean]
				def update(values = {}, options = {}, resource = nil, request_method = RequestMethods::PUT, format = 'json')
					self.set_attributes_by_hash values
					assert_validation( options ) do
						request_url = self.class.build_request_url( resource, format, self.id ) 
						do_save_request( request_url, request_method )
					end
				end

				# Updates object in the database
				# return [Boolean]
				def update!(request_url, values = {}, options = {}, request_method = RequestMethods::PUT)
					self.set_attributes_by_hash values
					self.save!( request_url, options, request_method )
				end

				# Destroys object in the database
				# return [Null]
				def destroy( resource = nil, request_method = RequestMethods::DELETE, format = 'json' )
					request_url = self.class.build_request_url( resource, format, self.id ) 
					destroy!( request_url, request_method )
				end

				# Destroys object in the database
				# return [Null]
				def destroy!( request_url, request_method = RequestMethods::DELETE )
					EApiClient::ActiveClient::JSON::Base.do_request( request_url, { id: self.id }, request_method )
				end

				#Instance methods

				def id
					raise NotImplementedError
				end		

				def id=(val)
					raise NotImplementedError
				end		

				private

				def do_save_request( request_url, request_method )
					result = EApiClient::ActiveClient::JSON::Base.do_request( request_url, self.to_request_object, request_method )
					save_success = false
					case result.code
					when StatusCodes::Created, StatusCodes::Ok
						save_success = true
						json_obj = Object::JSON.parse(result.to_s, symbolize_names: true)
						self.id = json_obj[ self.class.get_model_request_single_name ][ :id ]
					when StatusCodes::UnprocessableEntity
						json_obj = Object::JSON.parse(result.to_s, symbolize_names: true)
						set_errors_from_response json_obj
					end
					return save_success
				end

				def set_errors_from_response(json_obj)
					json_obj.each do |key, arr_val|
						arr_val.each do | err_desc |
							errors.add(key, err_desc)
						end
					end
				end

				def assert_validation(options = {}, &block)
					if options[:validate].nil? 
						save_result =	self.valid?
					else
						save_result = !options[:validate] ? true : self.valid?
					end
					if save_result
						return block.call
					else
						return save_result
					end
				end

			end

		end		
	end
end
