module WebDav
class Dispatcher < Pluginable
	
	attr_reader :port
	
	def initialize(port)
		@port = port
		
		super()
		activate_plugin("default")
		
		mount("/data/", $CONFIG.get("CORE_DATA_DIR").get_value)
	end
	
end
end
