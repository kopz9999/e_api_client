module EApiClient
  module ActiveClient
    module JSON

      class Query

        #Attributes definition

        private

        attr_accessor :pluggable_class

        public

        attr_accessor :request_method
        attr_accessor :format
        attr_accessor :url
        attr_writer :loaded

        #Methods definition

        public

        def loaded?
          @loaded
        end

        def initialize( pluggable_class_val, url_val, query_parameters_val = {}, request_method_val = RequestMethods::GET, format_val = 'json' )
          self.pluggable_class = pluggable_class_val
          self.url = url_val
          query_parameters.merge!( query_parameters_val )
          self.request_method = request_method_val
          self.format = format_val
          self.loaded = false
        end

        def where( query_parameters_val = {} )
          query_parameters.merge!( query_parameters_val )
        end

        def fetch
          raw_results = pluggable_class.request_handler.request_collection self.url, query_parameters, request_method, format
          pluggable_class.response_handler.response_collection raw_results, self.results
          self.loaded = true
        end

        def unload
          results.clear          
          self.loaded = false
        end

        def method_missing(method, *args)
          if results.respond_to? method
            self.fetch unless self.loaded?
            results.send(method, *args)
          else
            super
          end
        end

        def results
          @results ||= []
        end
        
        private

        def query_parameters
          @query_parameters ||= {}
        end

      end

    end
  end
end