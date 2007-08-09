#
# Ayuda para la generacion de numeros aleatorios
#
module Auth
class Rand
	
	srand(Time.now.to_f*100000)
	
	#
	# Genera los valores [a-zA-Z0-9]
	#
	@@values = Array.new
	"a".upto("z") { |l| @@values.push(l); @@values.push(l.upcase) }
	"0".upto("9") { |l| @@values.push(l) }
	
	#
	# Genera una llave aleatorio comformada unicamente
	# por letras y numeros
	#
	def self.rand_key()
		# Crea un string del tamaño por defecto para las llaves
		key_size = $CONF.get("AUTH_KEY_SIZE").value.to_i
		ret = " " * key_size
		key_size.times { |i| ret[i] = @@values[rand(@@values.size)] }
		return ret
	end
	
end
end
