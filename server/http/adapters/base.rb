module HTTP
module Adapters

class Base
	
	attr :server, :port
	
	def start()
	end
	
	def stop()
	end
	
	def self.avaliable()
		return false
	end
	
end
end
end

