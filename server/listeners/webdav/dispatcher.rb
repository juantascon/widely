module WebDav
class Dispatcher < Pluginable
	
	attr_reader :port, :server
	
	def initialize(port)
		@port = port
		
		super()
		activate_plugin("default")
		
		init_server()
		mount("/data/", $CONFIG.get("CORE_DATA_DIR").get_value)
	end
	
end
end
