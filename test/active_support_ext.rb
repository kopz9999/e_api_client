class ActiveSupport::TestCase

	setup do
		@server = RakeUp::ServerTask.new
		@server.custom_initialize
		@server.custom_start
	end

	teardown do
		@server.custom_end
	end

end
