#
# Manejador de Copia de Trabajo
# TODO:
# terminar status()
#

module WC
class WorkingCopy < WPluginable
	
	WC_BASE_DIRNAME = "wcs"
	
	attr_reader :user, :name, :repository
	attr_reader :collectable
	
	def initialize(user, repository, name, manager)
		@user = user
		@name = name
		@repository = repository
		
		@collectable = Collectable.new(self, @name)
		w_debug("new: #{@collectable.to_s}")
		
		if File.basename(File.cleanpath(self.dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)")
		end
		
		super()
		activate_wplugin(manager)
	end
	
	def dir
		"#{@user.data_dir}/#{WC_BASE_DIRNAME}/#{@name}"
	end
	
end
end
