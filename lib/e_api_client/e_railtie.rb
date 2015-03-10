module EApiClient


	class ERailtie < Rails::Railtie

		def load_dependencies
  		require 'rest-client'
		end

		def load_configuration
			configuration_file = "#{Rails.root.to_s}/config/api.yml"
			if File.exist? configuration_file
				config = YAML.load_file(configuration_file)
				endpoint = config[ Rails.env ][ "endpoint" ]
				EApiClient::ActiveClient::JSON::Pluggable.global_base_url = endpoint
			else
				EApiClient::Util.print "Endpoints should be provided on #{configuration_file}\nThey have to be provided manually"
			end
		end

		def init_environment
			set_rest_client			
		end

		def set_rest_client
			RestClient.log = Logger.new(STDOUT)
		end

	  initializer "require dependencies" do
	  	load_dependencies
			load_configuration	  	
			init_environment
	  end

	end

end
