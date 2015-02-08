module EApiClient
	module ActiveClient
		module JSON

			#The following methods simulate active record but with REST API
			module Activable

				extend ActiveSupport::Concern

				#Class Level Methods and variables
				included do

					extend ActiveModel::Callbacks

					define_model_callbacks :create, only: [:after, :before]
					define_model_callbacks :update, only: [:after, :before]
					define_model_callbacks :save, only: [:after, :before]
					define_model_callbacks :destroy, only: [:after, :before]

					# Class::where
					# Generate an array of this class instances by consuming the service
					# - parameters: request parameters
					# - resource: path of the service
					# - request_method: Enum to get GET, POST, PUT, DELETE
					# - format: url format
					# return [Array]
					def self.where(parameters, resource = nil, request_method = RequestMethods::GET, format = 'json' )
						request_url = self.build_request_url( resource )
						self.select!( request_url, parameters, request_method, format )
					end

					# Class::select
					# Generate an array of this class instances by consuming the service
					# - resource: path of the service
					# - parameters: request parameters
					# - request_method: Enum to get GET, POST, PUT, DELETE
					# - format: url format
					# return [Array]
					def self.select(resource = nil, parameters = {}, request_method = RequestMethods::GET, format = 'json' )
						request_url = self.build_request_url( resource )
						self.select!( request_url, parameters, request_method, format )
					end

					# Class::select!
					# Generate an array of the service, but it acts in a direct url
					# - request_url (required): url of the service
					# - parameters: request parameters
					# - request_method: Enum to get GET, POST, PUT, DELETE
					# - format: url format
					# return [Array]
					def self.select!(request_url, parameters = {}, request_method = RequestMethods::GET, format = 'json' )
						results = []
						json_response = Pluggable.get_json(request_url, parameters, request_method, format)
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

					# Class::create
					# Generate an instance recently created
					# - values: hash with values
					# - options: save options
					# - resource: path of the service
					# - request_method: Enum to get GET, POST, PUT, DELETE					
					# - format: url format
					# return [Object]
					def self.create(values = {}, options = {}, resource = nil, request_method = RequestMethods::POST, format = 'json')
						request_url = self.build_request_url( resource )
						self.create!( request_url, values, options, request_method, format )
					end

					# Class::create!
					# Generate an instance recently created, but it acts in a direct url
					# - request_url (required): url of the service
					# - values: hash with values
					# - options: save options
					# - request_method: Enum to get GET, POST, PUT, DELETE					
					# - format: url format
					# return [Object]
					def self.create!(request_url, values = {}, options = {}, request_method = RequestMethods::POST, format = 'json')
						curr_ptr = self.new( values )
						curr_ptr.save!( request_url, options, request_method, format )
						return curr_ptr
					end

					# Class::find
					# Finds object in the database
					# - id: hash with values
					# - resource: path of the service
					# - request_method: Enum to get GET, POST, PUT, DELETE
					# - format: url format
					# return [Object]
					def self.find(id, resource = nil, request_method = RequestMethods::GET, format = 'json')
						if id.nil?
							return nil
						else
							request_url = self.build_request_url( resource, id ) 
							return self.find!(request_url, request_method, format)
						end
					end

					# Class::find!
					# Finds object in the database
					# - request_url (required): url of the service
					# - request_method: Enum to get GET, POST, PUT, DELETE
					# - format: url format
					# return [Object]
					def self.find!(request_url, request_method = RequestMethods::GET, format = 'json')
						json_response = Pluggable.get_json(request_url, {}, request_method, format)
						curr_ptr = nil
						unless json_response.nil?
							json_result = Pluggable.verify_json( self.get_model_response_single_name, json_response)
							curr_ptr = self.instance_by_json( json_result )
						end
						return curr_ptr
					end

					#Instance methods

					# Class#id
					# Gets remote id
					# return [Integer]
					def id
						raise NotImplementedError
					end		

					# Class#id
					# Sets remote id
					# return [Integer]
					def id=(val)
						raise NotImplementedError
					end

					# Class#destroy
					# Destroys object in the database
					# - resource: path of the service
					# - request_method: Enum to get GET, POST, PUT, DELETE
					# - format: url format
					# return [Null]
					def destroy( resource = nil, request_method = RequestMethods::DELETE, format = 'json' )
						request_url = self.class.build_request_url( resource, self.id ) 
						destroy!( request_url, request_method, format )
					end

					# Class#destroy!
					# Destroys object in the database
					# - request_url (required): url of the service
					# - request_method: Enum to get GET, POST, PUT, DELETE					
					# - format: url format
					# return [Null]
					def destroy!( request_url, request_method = RequestMethods::DELETE, format = 'json' )
						run_callbacks :destroy do
							Pluggable.do_request( request_url, { id: self.id }, request_method, format )
						end
					end

					# Class#update
					# Updates object in the database
					# Url generation not efficient, but moved here due to DRY Principles
					# - values: hash with values
					# - options: save options
					# - resource: path of the service
					# - request_method: Enum to get GET, POST, PUT, DELETE					
					# - format: url format
					# return [Boolean]
					def update(values = {}, options = {}, resource = nil, request_method = RequestMethods::PUT, format = 'json')
						request_url = self.class.build_request_url( resource, self.id ) 
						self.update! request_url, values, options, request_method, format
					end

					# Class#update!
					# Updates object in the database
					# - request_url (required): url of the service
					# - values: hash with values
					# - options: save options
					# - request_method: Enum to get GET, POST, PUT, DELETE					
					# - format: url format
					# return [Boolean]
					def update!(request_url, values = {}, options = {}, request_method = RequestMethods::PUT, format = 'json')
						self.set_attributes_by_hash values
						run_callbacks :update do
							self.save!( request_url, options, request_method, format )
						end
					end

					# Class#save
					# Saves object to the database
					# Url generation not efficient, but moved here due to DRY Principles
					# - options: save options
					# - resource: path of the service
					# - request_method: Enum to get GET, POST, PUT, DELETE					
					# - format: url format
					# return [Boolean]
					def save(options = {}, resource = nil, request_method = nil, format = 'json')
						request_url = self.class.build_request_url( resource, self.id ) 
						self.save! request_url, options, request_method, format
					end

					# Class#save!
					# Saves object to the database
					# - request_url (required): url of the service
					# - options: save options
					# - request_method: Enum to get GET, POST, PUT, DELETE					
					# - format: url format
					# return [Boolean]
					def save!(request_url, options = {}, request_method = nil, format = 'json')
						assert_validation( options ) do
							rmeth = eval_method( request_method )
							assert_save_or_create do
								do_save_request( request_url, rmeth, options, format )
							end

						end
					end

				end

			end
			
		end		
	end
end
