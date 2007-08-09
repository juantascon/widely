#
# Un repositorio
#

module Repo

class Repository < WPluginable
	
	include WStorage::Storable
	include FileUtils
	
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
		raise wex_arg("owner", @owner) if ! @owner.kind_of? User::WUser
		
		wplugin_activate(@manager)
		wplugin_init()
		
		w_debug("new: #{@owner} #{@name} #{@manager}")
	end
	
	#
	# Inicia el repositorio desde datos obtenidos del almacenamiento
	#
	def initialize_from_storage(data)
		owner = User::UserSet.instance.get_ex(data["owner"])
		name = data["name"]
		manager = data["manager"]
		w_debug("restoring object: REPO[owner:#{owner.user_id} name:#{name}]")
		
		initialize(owner, name, manager, true)
	end
	
	#
	# Destruye los datos del repositorio
	#
	def destroy()
		@owner.wcset.each do |key, wc|
			wc.destroy if wc.repo == self
		end
		
		rm_rf(File.dirname(@data_dir))
		@owner.reposet.delete_by_object(self)
	end
	
	#
	# Convierte el repositorio en Hash
	#
	def to_h()
		{ "name" => @name, "manager" => @manager, "owner" => @owner.user_id }
	end
	
end

#
# Registra en cada usuario una coleccion de repositorios
#
User::ExtraAttrs.instance.add(:reposet) do |user, from_storage|
	storager = WStorage::DistributedStorager.new(Repository, "#{user.data_dir}/repos/%s/repo.conf")
	storager.load_all if from_storage
	storager
end

end
