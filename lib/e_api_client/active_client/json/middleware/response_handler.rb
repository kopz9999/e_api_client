module EApiClient
  module ActiveClient
    module JSON

      module Middleware

        class RequestHandler

          include EApiClient::ActiveClient::JSON::Middleware::Responsable

          def response_member(string_json_object)
            unless string_json_object.nil?
              json_hash = Object::JSON.parse(string_json_object, symbolize_names: true)
              obj = self.pluggable_class.instance_by_json( json_hash )
              json_hash[:errors].each do |key, arr_val|
                arr_val.each do | err_desc |
                  obj.errors.add(key, err_desc)
                end
              end
              return obj
            else
              return nil
            end
          end

          def response_collection(string_json_collection, enumerable_collection)
            unless string_json_collection.nil?
              json_results = Object::JSON.parse(string_json_collection, symbolize_names: true)
              json_results.each do | json_hash |
                enumerable_collection << self.pluggable_class.instance_by_json( json_hash )
              end
            end
          end

        end

      end

    end
  end
end