module EApiClient


	class ERailtie < Rails::Railtie
	  initializer "require dependencies" do
  		require 'rest-client'
	  end
	end

end
