#
# Manejador de Copia de Trabajo
# TODO:
# terminar status()
#

module WC
class WorkingCopy
	
	WC_BASE_DIRNAME = "wcs"
	
	include DynamicDelegator
	
	attr_reader :user, :name, :repository
	attr_reader :collectable
	
	def initialize(user, repository, name, manager_id=:default)
		@user = user
		@name = name
		@repository = repository
		
		@collectable = Collectable.new(self, @name)
		w_debug("new: #{@collectable.to_s}")
		
		if File.basename(File.cleanpath(self.dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)")
		end
		
		start_forward(manager_id)
	end
	
	def dir
		"#{@user.data_dir}/#{WC_BASE_DIRNAME}/#{@name}"
	end
	
end
end
