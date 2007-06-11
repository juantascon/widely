module Repos
class Repository < WPluginable
	
	REPOS_BASE_DIRNAME = "repos"
	
	attr_reader :owner, :name, :data_dir
	alias :collectable_key :name
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	def initialize(owner, name, manager)
		@owner = owner
		@name = name
		@manager = manager
		
		initialize2
		
		w_debug("new: #{@owner} #{@name} #{@manager}")
	end
	
	def initialize2()
		@data_dir = "#{@owner.data_dir}/#{REPOS_BASE_DIRNAME}/#{@name}"
		
		if File.basename(File.cleanpath(@data_dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)") 
		end
		
		activate_wplugin(@manager)
		init_repos()
	end
	
	def to_h()
		{ "name" => @name, "manager" => @manager, "owner" => @owner.user_id }
	end
	
	def load(data)
		@name = data["name"]
		@manager = data["manager"]
		@owner = UserSet.instance.get(data["owner"])
		
		initialize2
	end
	
end
end
