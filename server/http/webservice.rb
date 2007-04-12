module HTTP
class WebService
	
	private
	
	@@webservice_objects = Array.new
	@@webservice_methods = Hash.new
	@@webservice_module_methods = Hash.new
	@@webservice_name = nil
	
	def self.webservice_name
		@@webservice_name
	end
	
	attr_reader :wso_id
	
	#
	# Obtiene un objeto del array de objetos de WebService
	#
	def self.find_by_wso_id(id)
		return @@webservice_objects[id] if @@webservice_objects.include?(id)
		return nil
	end
	
	#
	# Registra la clase(self) como un WebService llamado :name en
	# el dispatcher
	#
	def self.webservice(name)
		@@webservice_name = name
		Dispatcher.set_webservice(self)
	end
	
	#
	# Registra el objeto self en el array de objetos de WebService
	#
	def webservice_object()
		@wso_id = @@webservice_objects.push(self).length - 1
	end
	
	#
	# Registra un metodo de instancia(debe ser public)
	# los argumentos variables (*args) y los que tienen valor por
	# defecto (var=value) no se deben registrar
	#
	# Ej:
	#
	# webservice_method :new
	# webservice_method :new => :param1
	# webservice_method :new => [ :param1, :param2, :param3 ]
	#
	def self.webservice_method(method_definition)
		if method_definition.kind_of? Symbol
			@@webservice_methods[method_definition] = Array.new
		elsif method_definition.kind_of? Hash
			params = method_definition.values[0]
			params = [params] if ! params.kind_of? Array
			(params + [method_definition.keys[0]]).each do |d|
				raise we_error("WebService", "Argument error: #{d}") if ! d.kind_of? Symbol
			end
			@@webservice_methods[method_definition.keys[0]] = params
		else
			raise we_error("WebService", "Argument error: #{method_definition}")
		end
	end
	
	#
	# Registra un metodo de modulo(static)
	# la sintaxis es igual a la de webservice_method
	#
	def self.webservice_module_method(method_definition)
		if method_definition.kind_of? Symbol
			@@webservice_module_methods[method_definition] = Array.new
		elsif method_definition.kind_of? Hash
			params = method_definition.values[0]
			params = [params] if ! params.kind_of? Array
			(params + [method_definition.keys[0]]).each do |d|
				raise we_error("WebService", "Argument error: #{d}") if ! d.kind_of? Symbol
			end
			@@webservice_module_methods[method_definition.keys[0]] = params
		else
			raise we_error("WebService", "Argument error: #{method_definition}")
		end
	end
	
	#
	# Hace un llamado al metodo ya sea de modulo o de instancia
	# comprueba que el metodo este registrado y que exista
	# ademas de que los argumentos pasados(hash) sean equivalentes a
	# los que estan registrados en el metodo de webservice
	#
	# * si es de instancia busca el objeto en el array de objetos de
	#   webservice utilizando el WebServiceObjectIdentificator(wso_id)
	# * si es de modulo simplemente lo llama e ignora el valor de wso_id
	#
	def self.call(method, args)
		method = method.to_sym if method.kind_of? String
		raise NoMethodError if ! method.kind_of? Symbol
		
		# El objeto al que le pertenece el metodo
		obj = nil
		
		# Los argumentos que se deben pasar al metodo
		method_args = nil
		
		if @@webservice_methods[method]
			#:method registrado como metodo de instancia
			raise NoMethodError if ! self.method_defined? method
			
			wso_id = args["wso_id"]
			args.delete "wso_id"
			
			method_args = @@webservice_methods[method]
			obj = find_by_wso_id(wso_id)
			raise ArgumentError.new("#{wso_id}: invalid wso_id") if ! obj
			
		elsif @@webservice_module_methods[method]
			#:method registrado como metodo de modulo(static)
			raise NoMethodError if ! self.public_methods.include?(method.to_s)
			method_args = @@webservice_module_methods[method]
			obj = self
			
		else
			#:method no esta registrado
			raise NoMethodError
		end
		
		#
		# Prueba que se le pasen los argumentos al metodo en el orden
		# y la cantidad correcta como ha sido espeficado
		#
		args_list = Array.new
		p "m", method_args
		p "a", args
		method_args.each do |method_arg|
			raise ArgumentError.new("missing argument: #{method_arg.to_s}") if ! args[method_arg]
			args_list.push args[method_arg]
		end
		
		#
		# Agrega los valores que aunque no estan registrados se han pasado
		# por alto ya sea por que es un metodo que recibe valores variables
		# o por que tiene valores por defecto
		#
		args.each do |key, value|
			args_list.push(value) if ! method_args.include? key
		end
		
		#
		# Realiza el llamado con el objeto que se encontro
		# y los argumentos ordenados y verificados
		#
		return obj.method(method).call(*args_list)
		
	end
	
end
end
