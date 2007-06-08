module Repos
class Repository < WPluginable
	
	REPOS_BASE_DIRNAME = "repos"
	
	attr_reader :name, :data_dir
	alias :collectable_key :name
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	def initialize(root_dir, name, manager)
		@name = name
		@data_dir = "#{root_dir}/#{REPOS_BASE_DIRNAME}/#{@name}"
		
		if File.basename(File.cleanpath(@data_dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)") 
		end
		
		super()
		activate_wplugin(manager)
		init_repos()
		
		w_debug("new: #{@name} #{@data_dir}")
	end
	
end
end
