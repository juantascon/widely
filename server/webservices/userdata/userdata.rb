module UserData

class UserData
	
	include WStorage::Storable
	
	attr_reader :key, :value, :owner
	alias :collectable_key :key
	
	def initialize(owner, key, value, from_storage=false)
		@owner = owner
		@key = key
		@value = value
		
		raise wex_arg("key", @key, "(nice try)") if ! validate_id(@key)
		raise wex_arg("owner", @owner) if ! @owner.kind_of? WUser
	end
	
	def initialize_from_storage(data)
		owner = WUser::Set.instance.get_ex(data["owner"])
		key = data["key"]
		value = data["value"]
		w_debug("restoring object: USERDATA[owner:#{owner.user_id} key:#{key} value:#{value}]")
		
		initialize(owner, key, value, true)
	end
	
	def to_h()
		{ "owner" => @owner.user_id, "key" => @key, "value" => @value }
	end
	
end

WUser::ExtraAttrs.instance.add(:userdataset) do |user, from_storage|
	storager = WStorage::DistributedStorager.new(UserData, "#{user.data_dir}/userdata/%s/userdata.conf")
	storager.load_all if from_storage
	storager
end

end
