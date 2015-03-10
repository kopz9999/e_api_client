module EApiClient
	module ActiveClient
		module JSON

			#The following methods simulate active record but with REST API
			module Activable

				module ClassMethods

					#Active Record like methods

					def all
						elements = query
						elements.fetch
						elements.results
					end

					# Class::create
					# Generate an instance recently created
					# - values: hash with values
					# - options: save options
					# - resource: path of the service
					# - request_method: Enum to get GET, POST, PUT, DELETE					
					# - format: url format
					# return [Object]
					def create(values = {}, options = {}, resource = nil, request_method = RequestMethods::POST, format = 'json')
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
					def create!(request_url, values = {}, options = {}, request_method = RequestMethods::POST, format = 'json')
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
					def find(id, resource = nil, request_method = RequestMethods::GET, format = 'json')
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
					def find!(request_url, request_method = RequestMethods::GET, format = 'json')
						json_response = self.request_handler.request_member(request_url, {}, request_method, format)
						json_result = self.pluggable_class.response_handler.response_member json_response
						return json_result.nil? ? nil : self.instance_by_json( json_result )
					end


					#Delegate to the query

	        def method_missing(method, *args)
	          query.send(method, *args)
	        end

	        #Override to customize your queries resource

	        def query_resource
	        	nil
	        end

	        def query
	        	EApiClient::ActiveClient::JSON::Query.new pluggable_class_val, build_request_url(query_resource)
	        end

				end

				module InstanceMethods

					extend ActiveModel::Callbacks

					define_model_callbacks :create, only: [:after, :before]
					define_model_callbacks :update, only: [:after, :before]
					define_model_callbacks :save, only: [:after, :before]
					define_model_callbacks :destroy, only: [:after, :before]

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

				extend ActiveSupport::Concern

				#Class Level Methods and variables

				included do

					#Required Modules
					include EApiClient::ActiveClient::JSON::Pluggable

					#Logic modules
					extend ClassMethods
					include InstanceMethods

				end

			end
			
		end		
	end
end
