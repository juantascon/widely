module WebDav
class Dispatcher < WPluginable
	
	attr_reader :port, :server
	
	def initialize(port, manager)
		@port = port
		
		super()
		activate_wplugin(manager)
		
		init_server()
		mount("/data/", $CONFIG.get("CORE_DATA_DIR").get_value)
	end
	
end
end
