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
		real_method.call(args)
	end
	
	#
	# Verifica que existan los argumentos dentro del hash
	# de argumentos
	# Ej:
	#
	# arg_check(args, "wso_id", "path")
	#
	def args_check(args, *arg_names)
		w_debug(args)
		arg_names.each do |arg_name|
			raise ArgumentError.new("args[#{arg_name}]: not included") if ! args.include? arg_name
		end
	end
end
