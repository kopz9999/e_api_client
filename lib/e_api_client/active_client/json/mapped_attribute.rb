module EApiClient
	module ActiveClient
		module JSON

			class MappedAttribute
				
        public

				attr_accessor :local_identifier
				attr_accessor :remote_identifier
        attr_accessor :attribute_name


        #Methods 

        public

        def define_attribute_for_class( cls )
          define_names
          ctx = self
          cls.class_eval do
            attr_accessor ctx.attribute_name

            unless ctx.attribute_name == ctx.local_identifier
              alias_method ctx.local_identifier, ctx.attribute_name
            end
          end
        end

        private

        def define_names
          self.attribute_name = local_identifier.to_s.parameterize.to_sym
        end

			end

		end		
	end
end
