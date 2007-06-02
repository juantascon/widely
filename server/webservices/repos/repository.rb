module Repos
class Repository < WPluginable
	
	REPOS_BASE_DIRNAME = "repos"
	
	attr_reader :user, :name
	alias :collectable_key :name
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	def initialize(user, name, manager)
		@user = user
		@name = name
		@data_dir = "#{@user.data_dir}/#{REPOS_BASE_DIRNAME}/#{@name}"
		
		w_debug("new: #{@name} #{@user}")
		
		if File.basename(File.cleanpath(@data_dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)") 
		end
		
		super()
		activate_wplugin(manager)
		init_repos()
	end
	
end
end
