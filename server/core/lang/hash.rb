#
# Modifica el metodo to_s de la clase Hash para facilitar el proceso de
# depuracion
#

class Hash
	
	#
	# Imprime la llave seguido de su valor y a su vez cada llave separada
	# por una "," de la siguiente llave
	#
	def to_s()
		ret = Array.new
		
		# Separa la llave de su valor por un " => "
		self.each { |key, value| ret.push "#{key.to_s} => #{value.to_s}" }
		
		# Separa cada llave de la siguiente por un ", "
		return ret.join(", ")
	end
	
end
