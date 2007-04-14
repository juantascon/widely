# 
# Metodos de ayuda en el parsing de cadenas
#
module Parser
	require "uri"
	
	def vars_to_values(str)
		str.gsub(/%[a-zA-Z0-9\.]+%/) do |m|
			self[m.gsub("%", "")]
		end
	end
	module_function :vars_to_values
	
	#
	# La cadena debe tener un patron de la forma "var1=value1&var2=value2 ... "
	# var y value deben estar en la forma url codificado
	# Ej:
	#
	# la cadena: "myname=1%3Dju%20%0D%26ao%09%0A&myid=0001&node=root"
	# retorna el hash: {:node=>"root", :myname=>"1=ju \r&ao\t\n", :myid=>"0001"}
	#
	def url_encoded_args_to_hash(str)
		ret = Hash.new
		
		str.split("&").each do |arg|
			key = arg.split("=", 2)[0]
			value = arg.split("=", 2)[1]
			ret[URI.decode(key).to_sym] = URI.decode(value)
		end
		
		return ret
	end
	
	module_function :url_encoded_args_to_hash

end
