#
# Metodos de ayuda en el parsing de urls
#

module URLParser
	
	# La cadena debe tener un patron de la forma "var1=value1&var2=value2 ... "
	# var y value deben estar en la forma url codificado
	# Ej:
	#
	# la cadena: "myname=1%3Dju%20%0D%26ao%09%0A&myid=0001&node=root"
	# retorna el hash: {:node=>"root", :myname=>"1=ju \r&ao\t\n", :myid=>"0001"}
	#
	def url_encoded_args_to_hash(str)
		ret = Hash.new
		return ret if ! str.kind_of? String
		
		str.split("&").each do |arg|
			key = arg.split("=", 2)[0]
			value = arg.split("=", 2)[1]
			ret[URI.decode(key)] = URI.decode(value) if (key and value)
		end
		
		return ret
	end
	
	module_function :url_encoded_args_to_hash
	
end
