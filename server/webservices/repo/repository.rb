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
		@data_dir = "#{owner.data_dir}/repos/#{@name}/data_dir" if ! @data_dir
		
		if (@name.include? "/" || @name[0..0] == ".") ||
			(File.basename(File.dirname(File.cleanpath(@data_dir))) != @name)
			raise ArgumentError, "invalid name: #{@name} (nice try)" 
		end
		
		wplugin_activate(@manager)
		wplugin_init()
		
		w_debug("new: #{@owner} #{@name} #{@manager}")
	end
	
	def initialize_from_storage(data)
		name = data["name"]
		manager = data["manager"]
		owner = UserSet.instance.get(data["owner"])
		
		initialize(owner, name, manager, true)
	end
	
	def to_h()
		{ "name" => @name, "manager" => @manager, "owner" => @owner.user_id }
	end
	
end

Auth::User.new_attr(:reposet) do |user, from_storage|
	collection = WStorage::DistributedStorager.new(Repository, "#{user.data_dir}/repos/%s/repo.conf")
	collection.load if from_storage
	collection
end

end
