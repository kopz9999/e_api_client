#API Client Gem

This gem provides a REST client for consuming a remote API. It is recommended to consume a REST source with the following gem https://github.com/kopz9999/e_api_server
<br/>
The architecture provides an ORM for the API. You just need to include the module <b>EApiClient::ActiveClient::JSON::Activable</b> in your model. It is recommended to create a configuration file with the endpoint for your resources: 

```ruby

development:
  endpoint: http://devapi:3003

test:
  endpoint: http://testapi:5000

production:
  endpoint: http://prodapi

```

## Model setup

Inside a model, you can also setup a custom endopoint for a model:

```ruby

class Api::Item

  base_url 'http://anotherapi'

end

```

In the following example, there is an assumption that you have the REST API http://devapi:3003/items
<br/>
Assuming the backend accepts the fields id, name and quantity for create and update with default Rails resources, you must configurate the following fields for CRUD operations:

```ruby

class Api::Item

  # Specify base resource for the model. For example :items, will set resource base to http://devapi:3003/items
  model_resources :items

  # Specify request base name. For example, request will encapsulate fields under item, like 'item { name: "desc", quantity: 10 }'
  request_element :item

  # Map each attribute from your class to the resource
  api_attr_accessor :id, :id
  api_attr_accessor :name, :name
  api_attr_accessor :quantity, :quantity  

  # Map with parse
  api_attr_accessor :created_at, :created_at, EApiClient::ActiveClient::JSON::DataParser::DateTime

end

```

With this set, you can start the consumption of a remote API.

## Collection Methods

The Activable module provides you a set of methods prepared to query a Remote API, just as ActiveRecord:

```ruby

  # Simple queries
  items = Api::Item.all # GET http://devapi:3003/items
  ordered_items = Api::Item.order(id: "asc") # GET http://devapi:3003/items?ordering[id]=asc
  items_page = Api::Item.page(2).per(3) # GET http://devapi:3003/items?pagination[page]=2&pagination[page_size]=3
  filtered_items = Api::Item.where(id: 12) # GET http://devapi:3003/items?id=12

  # Mix queries
  mixed_query = Api::Item.order(id: "desc").where(id: 32 ) # GET http://devapi:3003/items?id=32&ordering[id]=desc

  # Custom query
  query_filter_items = Api::Item.remote_query(resource: 'items/custom_resource', params: { quantity: 32 }) # GET http://devapi:3003/items/custom_resource?quantity=32

  # Search
  item_instance = Api::Item.find(32) # GET http://devapi:3003/items?id=32

  # Create
  item_instance_2 = Api::Item.create( name: "Item 32", quantity: 23.2 ) # POST http://devapi:3003/items
  # Request Params: { item: { name: "Item 32", quantity: 23.2 } }

```

Please note that ordering and query fields must be configured in the REST API according to the specifications of EApiServer.
<br/>
This library also provides instance methods:

```ruby
  
  item = Api::Item.create( name: "Item 1", quantity: 23.2 ) # POST http://devapi:3003/items
  # Request Params: { item: { name: "Item 1", quantity: 23.2 } }
  item.update( name: "Item 1 updated" ) # PUT http://devapi:3003/items/12
  # Request Params: { item: { name: "Item 1 updated" }, quantity: 23.2 }
  
  item2 = Api::Item.new
  item2.name = "Item 2"
  item2.save # POST http://devapi:3003/items
  # Request Params: { item: { name: "Item 2", quantity: 0 } }

  item2.quantity = 32
  item2.save # PUT http://devapi:3003/items/13
  # Request Params: { item: { name: "Item 2", quantity: 32 } }

  item2.destroy # DELETE http://devapi:3003/items/13

```

## Extra configuration

You can set your own middleware for requests and response handling:

```ruby

class Api::Item

  middleware_request_handler MyRequestHandler
  middleware_response_handler MyResponseHandler

end

```

Check documentation to create your own middleware:

[RequestHandler](docs/middleware/request.md)
[ResponseHandler](docs/middleware/response.md)

You can set your own data parsers for certain fields:

```ruby

  # Map with custom parse
  api_attr_accessor :created_at, :created_at, EApiClient::ActiveClient::JSON::DataParser::DateTime  

```

Check documentation to create your own parser:

[DataParser](docs/data_parser.md)

Please check the test cases to have a better understanding of how to use the activable module methods:

[Collection Examples](test/dummy/test/models/collection_test.rb)
[Member Examples](test/dummy/test/models/member_test.rb)
[Error Examples](test/dummy/test/models/error_test.rb)
[Parser Example](test/dummy/test/models/property_test.rb)

To test these methods you need to run test dummy on localhost:3003

<br/>
## TODO
* Support for Batch requests
* Add runtime attributes or attributes(*args) support.

<br/>
#Copyright 2015 Kyoto Kopz kopz9999@gmail.com

#License

Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with this
work for additional information regarding copyright ownership.  The ASF
licenses this file to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
License for the specific language governing permissions and limitations under
the License.
