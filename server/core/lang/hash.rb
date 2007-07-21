#
# Modifica el metodo to_s de la clase Hash de forma que
# facilite la depuracion
#

class Hash
	def to_s()
		ret = Array.new
		self.each { |key, value| ret.push "#{key.to_s} => #{value.to_s}" }
		return ret.join(", ")
	end
end
