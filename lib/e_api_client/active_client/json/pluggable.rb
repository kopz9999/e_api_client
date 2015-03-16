module EApiClient
  module ActiveClient
    module JSON

      module Pluggable

        module ClassMethods

          def request_handler
            @request_handler ||= EApiClient::ActiveClient::JSON::Middleware::RequestHandler.new
          end

          def response_handler
            @response_handler ||= EApiClient::ActiveClient::JSON::Middleware::ResponseHandler.new( self )
          end

          def api_attr_accessor(local_attribute, remote_attribute, data_parser_class = nil)
            current_attr = MappedAttribute.new.tap do | ma |
              ma.local_identifier = local_attribute
              ma.remote_identifier = remote_attribute
            end

            define_attribute current_attr
            set_data_parser(current_attr, data_parser_class) unless data_parser_class.nil?

            self.api_attributes << current_attr
          end
          
          # Generates object with the values given from a json
          # return [Object]
          def instance_by_json(json_obj = {})
            obj = self.new 
            obj.set_attributes_by_json( json_obj )
            return obj
          end

          def middleware_request_handler(value)
            @request_handler = value
          end

          def middleware_response_handler(value)
            @response_handler = value
          end

          private

          def define_attribute( mapped_attribute )
            self.class_eval do
              attr_accessor mapped_attribute.local_identifier.to_sym
            end
          end

          def set_data_parser( mapped_attribute, data_parser_class )
            data_parser = data_parser_class.new
            alias_name = "#{mapped_attribute.local_identifier}_s".to_sym
            instance_name = "@parsed_#{mapped_attribute.local_identifier}".to_sym
            retrieve_method = "retrieve_#{mapped_attribute.local_identifier}".to_sym

            define_method( retrieve_method ) do
              return data_parser.transform self.send( alias_name )
            end

            self.class_eval do
              alias_method(alias_name, mapped_attribute.local_identifier)
              private retrieve_method
            end

            define_method( mapped_attribute.local_identifier ) do
              if data_parser.persistent?
                val = instance_variable_get instance_name
                instance_variable_set(instance_name, self.send( retrieve_method )) if val.nil?
              else
                val = self.send( retrieve_method )
              end
              return val
            end

          end

        end

        module InstanceMethods

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
            result[ self.class.get_request_element ] = request_obj
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
            result = self.class.request_handler.request_member( request_url, self.to_request_object, request_method, format )
            self.class.response_handler.response_member result, self
            return result.code < 400
          end

          def assert_validation(options = {}, &block)
            if options[:validate].nil? 
              save_result =  self.valid?
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

        extend ActiveSupport::Concern

        #Class Level Methods and variables
        included do

          #Allow client side validations
          include ActiveModel::Validations
          include EApiClient::ActiveClient::JSON::Configurable

          #Functionality methods
          extend ClassMethods
          include InstanceMethods

        end

      end

    end    
  end
end
