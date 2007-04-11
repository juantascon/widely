#
# Extiende la clase File con metodos propios de la clase Pathname
# (si estan en File es mas comodo)
#

class File
	def self.cleanpath(path)
		Pathname.new(path).cleanpath.to_s
	end
	
	def self.relative?(path)
		Pathname.new(path).relative?
	end
	
	def self.absolute?(path)
		Pathname.new(path).absolute?
	end
	
	def self.root?(path)
		Pathname.new(path).root?
	end		
end
