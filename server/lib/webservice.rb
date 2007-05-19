module WebService
	#
	# Hace un llamado al metodo, comprueba que el metodo exista
	# y que reciba el numero correcto de argumentos de entrada
	# (1 hash)
	#
	def call(method, args)
		method = method.to_s
		
		begin
			real_method = method(method)
		rescue
			raise NoMethodError.new("method[#{method}]: not exists")
		end
		
		# El metodo debe recibir un solo parametros (un hash con los valores de entrada)
		raise ArgumentError.new("method[#{method}]: invalid definition") if real_method.arity != 1
		real_method.call(Args.new(args))
	end
	
	class Args < Hash
		def initialize(hash=nil)
			self.replace(hash)
		end
		
		#
		# Verifica que existan los argumentos dentro del hash
		# de argumentos
		# Ej:
		#
		# arg_check(args, "wso_id", "path")
		#
		def check(*arg_names)
			arg_names.each do |arg_name|
				raise ArgumentError.new("args[#{arg_name}]: not included") if ! self.include? arg_name
			end
		end
		
		def collection_get(collection, *args)
			real_args = Array.new
			args.each { |arg| real_args.push(self[arg]) }
			
			obj = collection.get_o(*real_args)
			raise ArgumentError.new("#{real_args}: #{collection.class.name} not found") if ! obj
			
			return obj
		end
	end
end
