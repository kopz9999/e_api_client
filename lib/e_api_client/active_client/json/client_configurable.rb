module EApiClient
	module ActiveClient
		module JSON

			module ClientConfigurable

				extend ActiveSupport::Concern

				included do

					def self.get_base_url
						@@base_url ||= EApiClient::ActiveClient::JSON::Base.global_base_url
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

					def self.get_model_request_single_name
						@@model_request_single_name ||= self.name.downcase.underscore.to_sym
					end

					def self.model_request_single_name(val)
						@@model_request_single_name = val
					end

					def self.get_model_request_plural_name
						@@model_request_plural_name ||= self.name.downcase.underscore.pluralize.to_sym
					end

					def self.model_request_plural_name( val )
						@@model_request_plural_name = val
					end

					def self.api_attributes
						@@api_attributes ||= []
					end

				end

			end
			
		end		
	end
end
