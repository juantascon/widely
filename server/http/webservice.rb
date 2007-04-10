module HTTP
module WebService
	
	attr_reader :name, :method_list
	@method_list = Array.new
	
	def webservice_register(name)
		@name = name
		Dispatch.set_webservice(self)
	end
	
	def webservice_method(*methods)
		methods.each do |m|
			@method_list.push(m) if m.kind_of? Symbol
		end
	end
		
end
end

