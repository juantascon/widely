class WebService
	
	#
	# Inicia la coleccion de objetos
	#
	def WebService.inherited(c)
		c.class_eval do
			@@webservice_objects = Array.new
		end
	end
	
	#
	# Hace un llamado al metodo, comprueba que el metodo exista
	# ademas de que los argumentos pasados(hash)
	#
	def self.call(method, args)
		method = method.to_s
		
		begin
			real_method = self.method(method)
		rescue
			raise NoMethodError.new("#{method} not exists")
		end
		
		# El metodo debe recibir un solo parametros (un hash con los valores de entrada)
		raise ArgumentError.new("#{method}: invalid method") if real_method.arity != 1
		real_method.call(args)
	end
	
	attr_reader :wso_id, :instance
	
	#
	# Registra un objeto dentro del array de objetos
	#
	def wso(instance)
		@instance = instance
		@wso_id = @@webservice_objects.push(@instance).length - 1
		return @wso_id
	end
	
	#
	# Obtiene un objeto del array de objetos de WebService
	#
	def find_wso(id)
		return @@webservice_objects[id] if @@webservice_objects.include?(id)
		raise ArgumentError.new("#{id}: invalid wso_id")
	end
	
	#
	# Verifica que existan los argumentos dentro del hash
	# de argumentos
	# Ej:
	#
	# arg_check(args, "wso_id", "path")
	#
	def args_check(args, *arg_names)
		arg_names.each do |arg_name|
			raise ArgumentError.new("#{arg_name} not included") if ! args.include? arg_name
		end
	end
	
end
