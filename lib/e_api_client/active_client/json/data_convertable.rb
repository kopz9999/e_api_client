module EApiClient
  module ActiveClient
    module JSON

      module DataConvertable

        extend ActiveSupport::Concern

        included do
          
          def self.api_date_time_attr(local_attribute, renamed_attribute = nil)

            alias_name = renamed_attribute.nil? ? "#{local_attribute}_s".to_sym : renamed_attribute
            new_name = local_attribute

            self.class_eval do
              alias_method(alias_name, new_name)
            end

            define_method( new_name ) do
              str_time = self.send( alias_name )
              str_time.nil? ? nil : str_time.to_datetime
            end

          end


        end  

      end

    end   
  end
end
