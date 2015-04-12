module EApiClient
	module ActiveClient
		module JSON

			module Configurable

				extend ActiveSupport::Concern

				# Global configuration

				def self.global_base_url
					@@global_base_url
				end

				def self.global_base_url=(global_base_url)
					@@global_base_url = global_base_url
				end

				module ClassMethods

					# Returns a URL based on configuration
					# return [String]
					def build_request_url( resource, param_key = nil )
						request_url = self.get_base_url
						url_param_key = ":#{self.model_name.param_key}"
						if resource.nil?
							request_url += "/#{self.get_model_resources}"
						else
							request_url += "/#{resource}"
						end
						if request_url.include?( url_param_key ) then request_url.sub! url_param_key, param_key.to_s
						else
							request_url += "/#{param_key}" unless param_key.nil?
						end
						return request_url
					end

					def get_base_url
						@base_url ||= EApiClient::ActiveClient::JSON::Configurable.global_base_url
					end

					def base_url(val)
						@base_url = val
					end

					def get_model_resources
						@model_resources ||= self.name.pluralize.underscore
					end

					def model_resources(val)
						@model_resources = val
					end

					def get_request_element
						@request_element ||= self.name.underscore.to_sym
					end

					def request_element(val)
						@request_element = val
					end					

					def api_attributes
						@api_attributes ||= []
					end

				end

			end
			
		end		
	end
end
