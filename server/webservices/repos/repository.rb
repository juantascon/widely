module Repos
class Repository
	
	include Collectable
	include DynamicDelegator
	
	attr_reader :user, :name
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	def initialize(user, name, manager_id=:default)
		w_debug("user: #{user} name: #{name} manager_id: #{manager_id} c_id: #{collectable_id}")
		
		@user = user
		@name = name
		
		if File.basename(File.cleanpath(self.dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)") 
		end
		
		start_forward(manager_id)
	end
	
	def dir
		"#{@user.data_dir}/#{$CONFIG.get(:REPOS_BASE_DIRNAME)}/#{@name}"
	end
	
	def collectable_id
		@name
	end
	
end
end
