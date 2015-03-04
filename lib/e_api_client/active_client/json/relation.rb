module EApiClient
  module ActiveClient
    module JSON

      class Relation < Array

        private

        attr_accessor :pluggable_class

        public

        def initialize( pluggable_class )
          pluggable_class = pluggable_class
        end

        

      end

    end
  end
end