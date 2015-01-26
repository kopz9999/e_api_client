module EApiClient

	module Util

		def self.print(message)
			Rails.logger.info(message)
			puts message
		end

	end

end
