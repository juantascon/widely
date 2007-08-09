# TODO: mover esta clase a httpapi

#
# Representa un webservice para un listener tipo API
#
module WebService
	
	#
	# LLama un metodo del webservice, comprueba que el metodo exista
	# y que reciba el numero correcto de argumentos de entrada
	# (1 hash)
	#
	# method: el metodo a llamar
	# args: los argumentos pasados al metodo
	#
	def call(method, args)
		method = method.to_s
		
		# Obtiene el metodo
		begin
			real_method = method(method)
		rescue
			raise NoMethodError.new("method[#{method}]: not exists")
		end
		
		# El metodo debe recibir un solo parametros (un hash con los valores de entrada)
		raise ArgumentError.new("method[#{method}]: invalid definition") if real_method.arity != 1
		
		# Hace el llamado al metodo
		return real_method.call(Args.new(args))
	end
	
	#
	# Representa los argumentos que se le pasan a un metodo
	# en un webservice
	#
	class Args < Hash
		
		#
		# Inicia los argumentos a partir de un array
		#
		def initialize(hash=nil)
			self.replace(hash)
		end
		
		#
		# Verifica que existan los argumentos para los nombres
		# dados
		# Ej:
		#
		# args.check("wso_id", "path")
		#
		def check(*arg_names)
			arg_names.each do |arg_name|
				raise ArgumentError.new("args[#{arg_name}]: not included") if ! self.include? arg_name
			end
		end
		
	end
	
end
