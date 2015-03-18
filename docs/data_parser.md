# DataParser

You can create your own data parsers for certain JSON attributes that are more than simple data type. To create your own parser, you must use the <b>Parseable</b> module and implement the necessary methods

```ruby

  class MyDataParser

    include EApiClient::ActiveClient::JSON::DataParser::Parseable

    # This method must return the transformed value from the JSON
    # @previous_value = original value coming from the JSON
    def transform( previous_value )
      #TODO: Logic here
    end

    # This method must return a boolean value that checks if your method should be parsed each time it is called (false), or stored once it is parsed (true)
    def persistent?
      # true | false
    end

  end


```