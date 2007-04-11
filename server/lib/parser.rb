# 
# Metodos de ayuda en el parsing de cadenas
# (este modulo tal vez sera borrado)
#
module Parser

	def vars_to_values(str)
		str.gsub(/%[a-zA-Z0-9\.]+%/) do |m|
			self[m.gsub("%", "")]
		end
	end
	module_function :vars_to_values

end
