module EApiClient
  module ActiveClient
    module JSON
      module DataParser

        module Parseable

          def transform( previous_value )
            raise NotImplementedError
          end
          
        end

      end
    end   
  end
end
