#
# Manejador de Copia de Trabajo
#

module WC

class WorkingCopy < WPluginable
	
	include WStorage::Storable
	include FileUtils
	
	DefaultWC = Repo::Version.new("-1")
	
	attr_reader :owner, :repo, :name, :data_dir
	alias :collectable_key :name
	
	#
	# Crea una copia de trabajo
	#
	# owner: el dueño
	# repo: el repositorio al que pertenece
	# manager: el plugin manejador a utilizar
	#
	def initialize(owner, repo, name, manager, from_storage=false)
		@owner = owner
		@repo = repo
		@name = name
		@manager = manager
		
		# El directorio de datos de la copia de trabajo
		@data_dir = "#{@owner.data_dir}/wcs/#{@name}/data_dir" if ! @data_dir
		
		raise wex_arg("name", @name, "(nice try)") if ! validate_id(@name)
		raise wex_arg("owner", @owner) if ! @owner.kind_of? User::WUser
		raise wex_arg("repo", @repo) if ! @repo.kind_of? Repo::Repository
		
		# Inicia el plugin indicado
		wplugin_activate(@manager)
		wplugin_init()
		
		w_debug("new: #{@name} #{@manager} #{@data_dir}")
	end
	
	#
	# Inicializa una wc desde datos de almacenamiento
	#
	def initialize_from_storage(data)
		owner = User::UserSet.instance.get_ex(data["owner"])
		repo = owner.reposet.get_ex(data["repo"])
		name = data["name"]
		manager = data["manager"]
		w_debug("restoring object: WC[owner:#{owner.user_id} name:#{name}]")
		
		initialize(owner, repo, name, manager, true)
	end
	
	#
	# Elimina la wc
	#
	def destroy()
		rm_rf(File.dirname(@data_dir))
		@owner.wcset.delete_by_object(self)
	end
	
	#
	# Convierte la copia de trabajo en Hash
	#
	def to_h()
		{ "repo" => @repo.name, "owner" => @owner.user_id, "name" => @name, "manager" => @manager }
	end
	
end

#
# Registra como datos extra en los usuario una coleccion de
# copias de trabajo
#
User::ExtraAttrs.instance.add(:wcset) do |user, from_storage|
	storager = WStorage::DistributedStorager.new(WorkingCopy, "#{user.data_dir}/wcs/%s/wc.conf")
	storager.load_all if from_storage
	storager
end

end
