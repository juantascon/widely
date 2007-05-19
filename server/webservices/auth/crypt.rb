module Auth
module Crypt
	
	def crypt(str)
		return str.crypt("salt"+str)
	end
	
	module_function :crypt
	
end
end
