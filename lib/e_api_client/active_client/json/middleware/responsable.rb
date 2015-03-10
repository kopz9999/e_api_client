module EApiClient
  module ActiveClient
    module JSON

      module Middleware

        module Responsable

          attr_accessor :pluggable_class

          #Override if you want to manage responses in another way
          def response_member(string_json_object)
            raise NotImplementedError
          end

          #Override if you want to manage responses in another way
          def response_collection(string_json_collection, enumerable_collection)
            raise NotImplementedError
          end

          #Forces you to build class with this constructor
          def initialize( pluggable_class_val )
            self.pluggable_class = pluggable_class_val
          end


        end

      end

    end
  end
end