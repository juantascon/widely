module FS
class Repository

class API < WebService
	
	def API.create(args)
		args_check(args, "manager")
		
		#
		# Todos los valores ordenados por el nombre de su
		# llave excepto el valor con llave "manager"
		#
		extra_args = Array.new
		args.keys.sort.each { |key| extra_args.push(args[key]) if key != "manager" }
		
		obj = Repository.new(args["manager"], extra_args)
		
		return wso(obj)
	end
	
end
end
