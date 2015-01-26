module EApiClient
	module ActiveClient
		module JSON

			#The following methods simulate active record but with REST API
			module Activable

				extend ActiveSupport::Concern

				#Class Level Methods and variables
				included do

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
						json_response = Pluggable.get_json(request_url, parameters, request_method)
						unless json_response.nil?
							json_results = Pluggable.verify_json(self.get_model_response_plural_name, json_response)
							curr_ptr = nil
							json_results.each do | json_hash |
								curr_ptr = self.instance_by_json( json_hash )
								results << curr_ptr
							end
							return results
						else
							return nil
						end
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

					# Updates object in the database
					# return [Object]
					def self.find(id, resource = nil, request_method = RequestMethods::GET, format = 'json')
						request_url = self.build_request_url( resource, format, id ) 
						self.find!(request_url, request_method)
					end

					# Updates object in the database
					# return [Object]
					def self.find!(request_url, request_method = RequestMethods::GET)
						json_response = Pluggable.get_json(request_url, {}, request_method)
						curr_ptr = nil
						unless json_response.nil?
							json_result = Pluggable.verify_json( self.get_model_response_single_name, json_response)
							curr_ptr = self.instance_by_json( json_result )
						end
						return curr_ptr
					end

					#Instance methods

					def id
						raise NotImplementedError
					end		

					def id=(val)
						raise NotImplementedError
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
						Pluggable.do_request( request_url, { id: self.id }, request_method )
					end

					# Updates object in the database
					# return [Boolean]
					def update(values = {}, options = {}, resource = nil, request_method = RequestMethods::PUT, format = 'json')
						self.set_attributes_by_hash values
						assert_validation( options ) do
							request_url = self.class.build_request_url( resource, format, self.id ) 
							do_save_request( request_url, request_method, options )
						end
					end

					# Updates object in the database
					# return [Boolean]
					def update!(request_url, values = {}, options = {}, request_method = RequestMethods::PUT)
						self.set_attributes_by_hash values
						self.save!( request_url, options, request_method )
					end

					# Saves object to the database
					# return [Boolean]
					def save(options = {}, resource = nil, request_method = RequestMethods::POST, format = 'json')
						assert_validation( options ) do
							request_url = self.class.build_request_url( resource, format ) 
							do_save_request( request_url, request_method, options )
						end
					end

					# Saves object to the database
					# return [Boolean]
					def save!(request_url, options = {}, request_method = RequestMethods::POST)
						assert_validation( options ) do
							do_save_request( request_url, request_method, options )
						end
					end

				end

			end
			
		end		
	end
end
