module EApiClient
  module ActiveClient
    module JSON

      module ActiveModelable

        extend ActiveSupport::Concern

        included do

          include ActiveModel::Conversion
          extend ActiveModel::Naming

          def new?
            self.id.nil?
          end

          def persisted?
            !new?
          end

        end  

      end

    end   
  end
end
