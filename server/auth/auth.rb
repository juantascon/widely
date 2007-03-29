module Auth
	def crypt(str)
		return str.crypt(str)
	end
	
	def rand_key()
		rand(9999999999999).to_s.crypt((rand(89)+10).to_s)
	end
	
	module_function :crypt, :rand_key
end
