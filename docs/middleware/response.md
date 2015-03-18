# Middleware Response
To create your own response middleware, you must use the <b>Responsable</b> module and implement the necessary methods.

```ruby

  class MyResponseHandler

    include EApiClient::ActiveClient::JSON::Middleware::Responsable

    # Manage response for memeber requests
    # @string_json_object - response from server
    # @obj - instance of the current model class that is doing the request. You should assign the string object properties to the object
    def response_member(string_json_object, obj)
      #TODO: Logic here
    end

    # Manage response for collection requests
    # @string_json_collection - response from server
    # @enumerable_collection - empty array to be filled by the response
    def response_collection(string_json_collection, enumerable_collection)
      #TODO: Logic here
    end

  end


```