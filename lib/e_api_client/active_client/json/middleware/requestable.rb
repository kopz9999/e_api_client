module EApiClient
  module ActiveClient
    module JSON

      module Middleware

        module Requestable

          #Override if you want to manage requests in another way
          def request_member(url, parameters, request_method, format)
            raise NotImplementedError
          end

          #Override if you want to manage requests in another way
          def request_collection(url, parameters, request_method, format)
            raise NotImplementedError
          end

        end

      end

    end
  end
end