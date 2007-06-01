module Repos
class Repository < Pluginable
	
	REPOS_BASE_DIRNAME = "repos"
	
	attr_reader :user, :name, :collectable
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	def initialize(user, name, manager)
		@user = user
		@name = name
		
		@collectable = Collectable.new(self, @name)
		w_debug("new: #{@collectable.to_s}")
		
		if File.basename(File.cleanpath(self.dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)") 
		end
		
		super()
		activate_plugin(manager)
	end
	
	def dir
		"#{@user.data_dir}/#{REPOS_BASE_DIRNAME}/#{@name}"
	end
	
end
end
