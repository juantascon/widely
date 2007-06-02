#
# Manejador de Copia de Trabajo
# TODO:
# terminar status()
#

module WC
class WorkingCopy < WPluginable
	
	WC_BASE_DIRNAME = "wcs"
	
	@@WC = Repos::Version.new("-1")
	def self.WC; @@WC; end
	
	attr_reader :user, :repository, :name, :data_dir
	alias :collectable_key :name
	
	def initialize(user, repository, name, manager)
		@user = user
		@repository = repository
		@name = name
		@data_dir = "#{@user.data_dir}/#{WC_BASE_DIRNAME}/#{@name}"
		
		w_debug("new: #{@name} #{@user}")
		
		if File.basename(File.cleanpath(self.data_dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name (what are you playing?)")
		end
		
		super()
		activate_wplugin(manager)
		init_wc()
	end
	
end
end
