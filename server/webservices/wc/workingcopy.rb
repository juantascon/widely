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
	
	attr_reader :repository, :name, :data_dir
	alias :collectable_key :name
	
	def initialize(repository, root_dir, name, manager)
		@repository = repository
		@name = name
		@data_dir = "#{root_dir}/#{WC_BASE_DIRNAME}/#{@name}"
		
		if File.basename(File.cleanpath(@data_dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name (what are you playing?)")
		end
		
		super()
		activate_wplugin(manager)
		init_wc()
		
		w_debug("new: #{@name} #{@data_dir}")
	end
	
end
end
