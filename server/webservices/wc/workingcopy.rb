#
# Manejador de Copia de Trabajo
#

module WC

class WorkingCopy < WPluginable
	
	include WStorage::Storable
	
	@@WC = Repo::Version.new("-1")
	def self.WC; @@WC; end
	
	attr_reader :owner, :repository, :name, :data_dir
	alias :collectable_key :name
	
	def initialize(owner, repository, name, manager, from_storage=false)
		@owner = owner
		@repository = repository
		@name = name
		@manager = manager
		
		@data_dir = "#{owner.data_dir}/wcs/#{@name}/data_dir" if ! @data_dir
		
		if (@name.include? "/" || @name[0..0] == ".") ||
			(File.basename(File.dirname(File.cleanpath(@data_dir))) != @name)
			raise ArgumentError, "invalid name: #{@name} (nice try)" 
		end
		
		wplugin_activate(@manager)
		wplugin_init()
		
		w_debug("new: #{@name} #{@manager} #{@data_dir}")
	end
	
	def initialize_from_storage(data)
		owner = UserSet.instance.get(data["owner"])
		repository = owner.repos.get(data["repository"])
		name = data["name"]
		manager = data["manager"]
		
		initialize(owner, repository, name, manager, true)
	end
	
	def to_h()
		{ "repository" => @repository.name, "owner" => @owner.user_id, "name" => @name, "manager" => @manager }
	end
	
end

Auth::User.new_attr(:wcset) do |user, from_storage|
	collection = WStorage::DistributedStorager.new(WorkingCopy, "#{user.data_dir}/wcs/%s/wc.conf")
	collection.load if from_storage
	collection
end

end
