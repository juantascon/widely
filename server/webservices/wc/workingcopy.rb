#
# Manejador de Copia de Trabajo
# TODO:
# terminar status()
#

module WC
class WorkingCopy
	
	include Collectable
	include DynamicDelegator
	
	attr_reader :user, :name, :repository
	
	def initialize(user, repository, name, manager_id=:default)
		w_debug("user: #{user} repository: #{repository} name: #{name} c_id: #{collectable_id}")
		
		@user = user
		@name = name
		@repository = repository
		
		if File.basename(File.cleanpath(self.dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)")
		end
		
		start_forward(manager_id)
	end
	
	def dir
		"#{@user.data_dir}/#{$CONFIG.get(:WC_BASE_DIRNAME)}/#{@name}"
	end
	
	def collectable_id
		@name
	end
	
end
end
