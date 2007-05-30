module Repos
class Repository
	
	REPOS_BASE_DIRNAME = "repos"
	
	include DynamicDelegator
	
	attr_reader :user, :name, :collectable
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	def initialize(user, name, manager_id=:default)
		@user = user
		@name = name
		
		@collectable = Collectable.new(self, @name)
		w_debug("new: #{@collectable.to_s}")
		
		if File.basename(File.cleanpath(self.dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)") 
		end
		
		start_forward(manager_id)
	end
	
	def dir
		"#{@user.data_dir}/#{REPOS_BASE_DIRNAME}/#{@name}"
	end
	
end
end
