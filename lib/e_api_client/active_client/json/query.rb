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
          self
        end

        def remote_query( opts )
          query_parameters_val = opts[:params] || {}
          url_val = opts[:url]
          resource = opts[:resource]
          request_method_val = opts[:request_method] || RequestMethods::GET
          format_val = opts[:format]

          url_val = pluggable_class.build_request_url( resource ) if url_val.nil?
          query_parameters.merge!( query_parameters_val )
          self.url = url_val
          self.request_method = request_method_val
          self.format = format_val

          self
        end

        def per( page_size )
          pagination_parameters[:page_size] = page_size
          self
        end

        def page( page_number )
          pagination_parameters[:page] = page_number
          self
        end

        def order( order_hash = {} )
          order_parameters.merge! order_hash
          self
        end

        def remote_fetch
          raw_results = pluggable_class.request_handler.request_collection self.url, query_parameters, request_method, format
          pluggable_class.response_handler.response_collection raw_results, self.results
          self.loaded = true
          self.results
        end

        def reload
          self.unload
          self.remote_fetch
        end

        def unload
          results.clear          
          self.loaded = false
        end

        def method_missing(method, *args, &block)
          if results.respond_to? method
            self.remote_fetch unless self.loaded?
            results.send(method, *args, &block)
          else
            super
          end
        end

        def results
          @results ||= []
        end
        
        private

        def pagination_parameters
          parameter_for :pagination
        end

        def order_parameters
          parameter_for :ordering
        end

        def parameter_for( key )
          query_parameters[ key ] ||= {}
          query_parameters[ key ]          
        end

        def query_parameters
          @query_parameters ||= {}
        end

      end

    end
  end
end