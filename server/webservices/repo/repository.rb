module Repo

class Repository < WPluginable
	
	include WStorage::Storable
	
	attr_reader :owner, :name, :data_dir
	alias :collectable_key :name
	
	#
	# Crea un nuevo objeto dependiendo del manejador a utilizar
	# en caso de fallo utiliza el manejador por defecto
	#
	def initialize(owner, name, manager, from_storage=false)
		@owner = owner
		@name = name
		@manager = manager
		@data_dir = "#{@owner.data_dir}/repos/#{@name}/data_dir" if ! @data_dir
		
		raise wex_arg("name", @name, "(nice try)") if ! validate_id(@name)
		raise wex_arg("owner", @owner) if ! @owner.kind_of? WUser
		
		wplugin_activate(@manager)
		wplugin_init()
		
		w_debug("new: #{@owner} #{@name} #{@manager}")
	end
	
	def initialize_from_storage(data)
		owner = WUser::Set.instance.get_ex(data["owner"])
		name = data["name"]
		manager = data["manager"]
		w_debug("restoring object: REPO[owner:#{owner.user_id} name:#{name}]")
		
		initialize(owner, name, manager, true)
	end
	
	def to_h()
		{ "name" => @name, "manager" => @manager, "owner" => @owner.user_id }
	end
	
end

WUser::ExtraAttrs.instance.add(:reposet) do |user, from_storage|
	storager = WStorage::DistributedStorager.new(Repository, "#{user.data_dir}/repos/%s/repo.conf")
	storager.load_all if from_storage
	storager
end

end
