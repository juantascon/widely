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
	
	attr_reader :owner, :repository, :name, :data_dir
	alias :collectable_key :name
	
	def initialize(owner, repository, name, manager)
		@owner = owner
		@repository = repository
		@name = name
		@manager = manager
		
		initialize2
		
		w_debug("new: #{@name} #{@manager} #{@data_dir}")
	end
	
	def initialize2
		@data_dir = "#{@owner.data_dir}/#{WC_BASE_DIRNAME}/#{@name}"
		
		if File.basename(File.cleanpath(@data_dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name (what are you playing?)")
		end
		
		activate_wplugin(@manager)
		init_wc()
	end
	
	def to_h()
		{ "repository" => @repository.name, "owner" => @owner.user_id, "name" => @name, "manager" => @manager }
	end
	
	def load(data)
		@owner = UserSet.instance.get(data["owner"])
		@repository = @owner.repos.get(data["repository"])
		@name = data["name"]
		@manager = data["manager"]
		
		initialize2
	end
	
end
end
