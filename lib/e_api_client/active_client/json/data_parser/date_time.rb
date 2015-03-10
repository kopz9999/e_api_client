module EApiClient
  module ActiveClient
    module JSON
      module DataParser

        class DateTime

          include EApiClient::ActiveClient::JSON::DataParser::Parseable

          def transform( previous_value )
            previous_value.nil? ? nil : previous_value.to_datetime
          end

        end

      end
    end   
  end
end
