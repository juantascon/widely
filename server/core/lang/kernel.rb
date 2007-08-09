#
# Extiende el modulo kernel con metodos que simplifican
# el acceso a informacion sobre el llamado desde otros metodo
#
# ej: caller_method:
#   retorna el nombre del metodo que invoco este metodo
#

module Kernel
	
	#
	# El metodo que ha llamado a este metodo
	#
	# back: de forma recursiva mira ademas el metodo que llamo al que llamo a este metodo ...
	#
	def caller_method(back=0)
		return $1 if /`(.*)'/.match(caller[back])
	end
	alias_method :method_name, :caller_method
	
	#
	# La linea donde se llamo este metodo
	#
	# back: de forma recursiva mira ademas la linea que llamo al que llamo a este metodo ...
	#
	def caller_line(back=0)
		return $1 if /:([0-9])/.match(caller[back])
	end
	
	#
	# El archivo que llamo a este metodo
	#
	# back: de forma recursiva mira ademas el archivo que llamo al que llamo a este metodo ...
	#
	def caller_file(back=0)
		return $1 if /(.*):[0-9]/.match(caller[back])
	end
	
end
