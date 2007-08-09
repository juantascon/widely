#
# Representa una peticion HTTP
#

module HTTPAPI

class RQ
	attr_reader :method, :path, :body 
	
	#
	# method: el metodo de la peticion (POST - GET - ...)
	# path: la ruta de la peticion
	# body: el cuerpo de la peticion (solo para POST)
	#
	def initialize(method, path, body)
		@method = method
		@path = path
		@body = body
	end
	
	#
	# Convierte la peticion en formato json
	#
	def to_json
		{"method" => method, "path" => path, "body" => body}.to_json
	end
end

end
