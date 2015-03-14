require 'rubygems'
require 'bundler/setup'
require 'rakeup'

class RakeUp::ServerTask

	def custom_initialize
		self.port = 3003
		self.pid_file = "test/dummy/server.pid" #{}"#{Rails.root.to_s}/server.pid" #'Tests/Server/server.pid'
		self.rackup_file = "test/dummy/config.ru"#{}"#{Rails.root.to_s}/config.ru"#'Tests/Server/server.ru'
		self.server = :webrick # Or puma, mongrel, etc.
	  @server_status = RakeUp::Status.new(nil, self.host, self.port)
	end

	def custom_start
	  refresh_status
	  unless @server_status.listening?
	  	puts "Starting server on #{@server_status.host_and_port}"
	    RakeUp::Shell.execute(self.start_command)
	    wait_to_start
	  end
	end

	def custom_end
		refresh_status
	  if @server_status.listening?
	  	puts "Ending server on #{@server_status.host_and_port}"
	    RakeUp::Shell.execute(self.stop_command)
	    wait_to_end
	  end
	end

	private

	def refresh_status
		@server_status.check
	end

	def wait_to_start
		loop do 
			sleep(1)
	  	refresh_status
			break if @server_status.listening?
		end
		p "Server is awake, lets test"
	end

	def wait_to_end
		loop do 
			sleep(1)
	  	refresh_status
			break unless @server_status.listening?
		end
		p "Server is down, test has ended"
	end

end
