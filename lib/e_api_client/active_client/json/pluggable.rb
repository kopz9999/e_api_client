module EApiClient
	module ActiveClient
		module JSON

			module Pluggable

				extend ActiveSupport::Concern

				#Module level static Logic Methods

				def self.global_base_url
					@@global_base_url
				end

				def self.global_base_url=(global_base_url)
					@@global_base_url = global_base_url
				end

				def self.do_request(url, parameters, request_method, format)
					default_handler = lambda{|response, request, result| response }
					case request_method 
						when RequestMethods::GET
							result = RestClient.get url, { params: parameters, :accept => format }, &default_handler
						when RequestMethods::POST
							result = RestClient.post url, parameters, { :accept => format }, &default_handler
						when RequestMethods::PUT
							result = RestClient.put url, parameters, { :accept => format }, &default_handler
						when RequestMethods::DELETE
							result = RestClient.delete url, { params: parameters, :accept => format }, &default_handler
					end
					result
				end

				def self.get_json(url, parameters, request_method, format)
					result = do_request( url, parameters, request_method, format )					
					if result.code < StatusCodes::BadRequest
						if result.code == StatusCodes::NoContent
							return nil
						else
							return Object::JSON.parse(result.to_s, symbolize_names: true)
						end
					else
						return nil
					end
				end

				# Returns filtered JSON
				# return [Hash]
				def self.verify_json( key, json_obj )
					result = json_obj
					result = json_obj[ key ] unless key.nil?
					result
				end

				#Class Level Methods and variables
				included do

					#Allow client side validations
					include ActiveModel::Validations
					include EApiClient::ActiveClient::JSON::Configurable
					include EApiClient::ActiveClient::JSON::Activable
					include EApiClient::ActiveClient::JSON::DataConvertable

					def self.api_attr_accessor(local_attribute, remote_attribute)
						current_attr = MappedAttribute.new

						self.class_eval("def #{local_attribute};@#{local_attribute};end")
						self.class_eval("def #{local_attribute}=(val);@#{local_attribute}=val;end")
						#self.attr_accessor local_attribute
						current_attr.local_identifier = local_attribute
						current_attr.remote_identifier = remote_attribute
						self.api_attributes << current_attr
					end

					# Generates object with the values given from a json
					# return [Object]
					def self.instance_by_json(json_obj = {})
						obj = self.new 
						obj.set_attributes_by_json( json_obj )
						return obj
					end

					# Returns a URL based on configuration
					# return [String]
					def self.build_request_url( resource, param_key = nil )
						request_url = self.get_base_url
						if resource.nil?
							request_url += "/#{self.get_model_resources}"
						else
							request_url += "/#{resource}"
						end
						request_url += "/#{param_key}" unless param_key.nil?
						#request_url += ".#{format}" unless format.nil?
						return request_url
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
						request_single_name = self.class.get_model_request_single_name
						self.class.api_attributes.each do |api_attr|
							request_obj[ api_attr.local_identifier ] = self.send( api_attr.local_identifier )
						end
						if request_single_name.nil?
							result = request_obj					
						else
							result[ request_single_name ] = request_obj
						end
						return result
					end

					private

					def eval_method( request_method )
						if request_method.nil?
							return self.id.nil? ? RequestMethods::POST : RequestMethods::PUT
						else
							return request_method
						end						
					end

					def assert_save_or_create(&block)
						if self.id.nil?
							run_callbacks :create do
								run_callbacks :save do
									block.call
								end
							end
						else
							run_callbacks :save do
								block.call
							end
						end						
					end

					def do_save_request( request_url, request_method, options = {}, format )
						result = EApiClient::ActiveClient::JSON::Pluggable.do_request( request_url, self.to_request_object, request_method, format )
						save_success = false

						case result.code
						when StatusCodes::Created, StatusCodes::Ok
							save_success = true
							eval_save_success result, options
						when StatusCodes::UnprocessableEntity
							json_obj = Object::JSON.parse(result.to_s, symbolize_names: true)
							set_errors_from_response json_obj
						else
							EApiClient::Util.print "Error on request. Unexpected response"
						end
						return save_success
					end

					def eval_save_success( result, options = {} )
						json_obj = Object::JSON.parse(result.to_s, symbolize_names: true)
						values_hash = EApiClient::ActiveClient::JSON::Pluggable.verify_json( self.class.get_model_response_single_name, json_obj )
						if options[:set_by_response]
							self.id = values_hash[ :id ]
						else
							self.set_attributes_by_json values_hash
						end
					end

					def set_errors_from_response(json_obj)
						json_obj[:errors].each do |key, arr_val|
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
end
