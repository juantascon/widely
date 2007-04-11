module HTTP
module WebService
	
	@@webservice_objects = Array.new
	attr_reader :wso_id, :name
	
	#
	# Obtiene un objeto del array de objetos de WebService
	#
	def self.find_by_wso_id(id)
		return @@webservice_objects[id]
	end
	
	#
	# Registra la clase(self) como un WebService llamado :name en
	# el dispatcher
	#
	def webservice(name)
		@name = name
		@method_list = Array.new
		@module_method_list = Array.new
		
		Dispatcher.set_webservice(self)
	end
	
	#
	# Registra el objeto en el array de objetos de WebService
	#
	def webservice_object()
		@wso_id = @@webservice_objects.push(self).length - 1
	end
	
	private :webservice, :webservice_object
	
	
	#
	# Registra metodos de instancia(deben ser public)
	#
	def webservice_method(*methods)
		methods.each do |m|
			@method_list.push(m) if m.kind_of? Symbol
		end
	end
	
	#
	# Registra metodos de modulo(static)
	#
	def webservice_module_method(*methods)
		methods.each do |m|
			@module_method_list.push(m) if m.kind_of? Symbol
		end
	end
	
	private :webservice_method, :webservice_module_method
	
	#
	# Hace un llamado al metodo ya sea de modulo o de instancia
	# comprueba que el metodo este registrado y que exista
	#
	# * si es de instancia busca el objeto en el array de objetos de webservice
	# * si es de modulo simplemente lo llama
	#
	def self.call(method)
		method = method.to_sym if method.kind_of? String
		raise NoMethodError if ! method.kind_of? Symbol
		
		if @method_list.include? method #:method registrado como metodo de instancia
			raise NoMethodError if ! method_defined? method
			
			obj = find_by_wso_id(id) #id no se conoce aqui, toca sacarlo de rq.body COMPLETAR
			return obj.method(method).call(args) #args no se conoce aqui, toca sacarlo de rq.body
			
		elsif @module_method_list.include? method #:method registrado como metodo de modulo(static)
			raise NoMethodError if ! self.public_methods.include?(method.to_s)
			
			return self.method(method).call(args) #args no se conoce aqui, toca sacarlo de rq.body
		else #:method no esta registrado
			raise NoMethodError
		end
	end
	
end
end

