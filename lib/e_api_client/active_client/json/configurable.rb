module EApiClient
	module ActiveClient
		module JSON

			module Configurable

				extend ActiveSupport::Concern

				#Class Level Methods and variables
				included do

					def self.get_base_url
						@@base_url ||= Pluggable.global_base_url
					end

					def self.base_url(val)
						@@base_url = val
					end

					def self.get_model_resources
						@@model_resources ||= self.name.downcase.underscore.pluralize
					end

					def self.model_resources(val)
						@@model_resources = val
					end

					def self.get_model_response_single_name
						@@model_response_single_name
					end

					def self.model_response_single_name(val)
						@@model_response_single_name = val
					end

					def self.get_model_request_single_name
						@@model_request_single_name
					end

					def self.model_request_single_name(val)
						@@model_request_single_name = val
					end					

					def self.get_model_response_plural_name
						@@model_response_plural_name
					end

					def self.model_response_plural_name( val )
						@@model_response_plural_name = val
					end

					def self.api_attributes
						@@api_attributes ||= []
					end

					def self.set_json_identifiers_by_class
						model_request_single_name self.name.downcase.underscore.to_sym
						model_response_single_name self.name.downcase.underscore.to_sym
						model_response_plural_name self.name.downcase.underscore.pluralize.to_sym						
					end

					def self.set_json_identifiers_by_default
						model_request_single_name nil
						model_response_single_name nil
						model_response_plural_name nil
					end

					set_json_identifiers_by_default

				end

			end
			
		end		
	end
end
