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
		
		@data_dir = "#{@owner.data_dir}/wcs/#{@name}/data_dir" if ! @data_dir
		
		raise wex_arg("name", @name, "(nice try)") if ! validate_id(@name)
		raise wex_arg("owner", @owner) if ! @owner.kind_of? Auth::User
		raise wex_arg("repository", @repository) if ! @repository.kind_of? Repo::Repository
		
		wplugin_activate(@manager)
		wplugin_init()
		
		w_debug("new: #{@name} #{@manager} #{@data_dir}")
	end
	
	def initialize_from_storage(data)
		owner = Auth::UserSet.instance.get_ex(data["owner"])
		repository = owner.repos.get_ex(data["repository"])
		name = data["name"]
		manager = data["manager"]
		
		initialize(owner, repository, name, manager, true)
	end
	
	def to_h()
		{ "repository" => @repository.name, "owner" => @owner.user_id, "name" => @name, "manager" => @manager }
	end
	
end

Auth::User.new_attr(:wcset) do |user, from_storage|
	storager = WStorage::DistributedStorager.new(WorkingCopy, "#{user.data_dir}/wcs/%s/wc.conf")
	storager.load_all if from_storage
	storager
end

end
