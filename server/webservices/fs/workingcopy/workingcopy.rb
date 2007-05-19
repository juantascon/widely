#
# Manejador de Copia de Trabajo
# TODO:
# terminar status()
#

module FS
class WorkingCopy
	
	include Collectable
	include DynamicDelegator
	
	attr_reader :user, :name, :repository
	
	def initialize(user, repository, name)
		w_debug("user: #{user} repository: #{repository} name: #{name} c_id: #{collectable_id}")
		
		@user = user
		@name = name
		@repository = repository
		
		if File.basename(File.cleanpath(self.dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)")
		end
		
		# Crea la instancia del manejador
		@manager = self.class.get_manager(:default).new(self)
		
		start_forward()
	end
	
	def dir
		"#{@user.data_dir}/#{$CONFIG.get(:FS_WC_DIR)}/#{@name}"
	end
	
	def collectable_id
		@name
	end
	
end
end
