module EApiClient
  module ActiveClient
    module JSON

      module Middleware

        class RequestHandler

          include EApiClient::ActiveClient::JSON::Middleware::Requestable

          def request_member(url, parameters, request_method, format)
            do_request(url, parameters, request_method, format)
          end

          def request_collection(url, parameters, request_method, format)
            do_request(url, parameters, request_method, format)
          end

          protected

          def do_request(url, parameters, request_method, format)
            #EApiClient::Util.print "Error on request. Unexpected response"
            default_handler = lambda do |response, request, result| 
              response
            end
            case request_method 
              when RequestMethods::GET
                result = RestClient.get "#{url}?#{parameters.to_query}", { :accept => format }, &default_handler
              when RequestMethods::POST
                result = RestClient.post url, parameters, { :accept => format }, &default_handler
              when RequestMethods::PUT
                result = RestClient.put url, parameters, { :accept => format }, &default_handler
              when RequestMethods::DELETE
                result = RestClient.delete url, { params: parameters, :accept => format }, &default_handler
            end
            result
          end

        end

      end

    end
  end
end