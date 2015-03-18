# Middleware Request
To create your own request middleware, you must use the <b>Requestable</b> module and implement the necessary methods. The default handler uses RestClient gem to do requests, you can do requests in the way you prefer.

```ruby

  class MyRequestHandler

    include EApiClient::ActiveClient::JSON::Middleware::Requestable

    # Manage request for memeber requests
    # @url - Url request
    # @parameters - Request parameters
    # @request_method - Request verb
    # @format - Url format
    def request_member(url, parameters, request_method, format)
      #TODO: Logic here
    end

    # Manage request for collection requests
    # @url - Url request
    # @parameters - Request parameters
    # @request_method - Request verb
    # @format - Url format
    def request_collection(url, parameters, request_method, format)
      #TODO: Logic here
    end

  end


```