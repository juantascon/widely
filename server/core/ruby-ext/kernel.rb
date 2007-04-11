#
# Extiende el modulo kernel con metodos que simplifican
# el acceso a informacion sobre el llamado desde otros metodo
# ej: caller_method:
#   retorna el nombre del metodo que invoco este
#   metodo
#
module Kernel
	def caller_method(back=0)
		return $1 if /`(.*)'/.match(caller[back])
	end
	alias_method :method_name, :caller_method
	
	def caller_line(back=0)
		return $1 if /:([0-9])/.match(caller[back])
	end
	
	def caller_file(back=0)
		return $1 if /(.*):[0-9]/.match(caller[back])
	end
end
