module EApiClient
  module ActiveClient
    module JSON

      module ActiveModelable

        module InstanceMethods

          def new?
            self.id.nil?
          end

          def persisted?
            !new?
          end

        end

        extend ActiveSupport::Concern        

        included do

          include ActiveModel::Conversion
          extend ActiveModel::Naming
          
          include InstanceMethods

        end  

      end

    end   
  end
end
