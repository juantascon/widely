#
# Extiende la clase File con metodos propios de la clase Pathname
# (si estan en File es mas comodo)
#

class File
	
	#
	# Limpia una ruta quitando los directorios ".." y "." ademas quita
	# los "/" de sobra
	#
	# path: la ruta a limpiar
	#
	def self.cleanpath(path)
		Pathname.new(path).cleanpath.to_s
	end
	
	#
	# Prueba si una ruta es una ruta relativa
	#
	# path: la ruta a probar
	#
	def self.relative?(path)
		Pathname.new(path).relative?
	end
	
	#
	# Prueba si una ruta es una ruta absoluta
	#
	# path: la ruta a probar
	#
	def self.absolute?(path)
		Pathname.new(path).absolute?
	end
	
	#
	# Prueba si una ruta es una ruta raiz
	#
	# path: la ruta a probar
	#
	def self.root?(path)
		Pathname.new(path).root?
	end
	
end
