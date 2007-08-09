module UserData

# Datos adicionales del usuario

class UserData
	
	include WStorage::Storable
	
	attr_reader :key, :value, :owner
	alias :collectable_key :key
	
	#
	# owner: el propietario
	# key: el nombre del dato
	# value: el valor del dato
	#
	def initialize(owner, key, value, from_storage=false)
		@owner = owner
		@key = key
		@value = value
		
		raise wex_arg("key", @key, "(nice try)") if ! validate_id(@key)
		raise wex_arg("owner", @owner) if ! @owner.kind_of? User::WUser
	end
	
	#
	# Carga un dato de usuario desde datos de almacenamiento
	#
	def initialize_from_storage(data)
		owner = User::UserSet.instance.get_ex(data["owner"])
		key = data["key"]
		value = data["value"]
		w_debug("restoring object: USERDATA[owner:#{owner.user_id} key:#{key} value:#{value}]")
		
		initialize(owner, key, value, true)
	end
	
	#
	# Convierte el dato en Hash
	#
	def to_h()
		{ "owner" => @owner.user_id, "key" => @key, "value" => @value }
	end
	
end

#
# Registra como datos extra en los usuario una coleccion de
# datos de usuario
#
User::ExtraAttrs.instance.add(:userdataset) do |user, from_storage|
	storager = WStorage::DistributedStorager.new(UserData, "#{user.data_dir}/userdata/%s/userdata.conf")
	storager.load_all if from_storage
	storager
end

end
