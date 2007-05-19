module FS
class Repository
	
	include Collectable
	include DynamicDelegator
	
	attr_reader :user, :name
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	def initialize(user, manager_id, name)
		w_debug("user: #{user} manager_id: #{manager_id} name: #{name} c_id: #{collectable_id}")
		
		@user = user
		@name = name
		
		if File.basename(File.cleanpath(self.dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)") 
		end
		
		# Crea la instancia del manejador
		begin
			@manager = self.class.get_manager(manager_id).new(self)
		rescue NoMethodError
			raise ArgumentError.new("#{manager_id}: invalid manager_id")
		end
		
		start_forward()
	end
	
	def dir
		"#{@user.data_dir}/#{$CONFIG.get(:FS_REPOS_DIR)}/#{@name}"
	end
	
	def collectable_id
		@name
	end
	
end
end
