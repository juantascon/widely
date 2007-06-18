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
		raise wex_arg("owner", @owner) if ! @owner.kind_of? Auth::User
	end
	
	def initialize_from_storage(data)
		owner = UserSet.instance.get_ex(data["owner"])
		key = data["key"]
		value = data["value"]
		
		initialize(owner, key, value, true)
	end
	
	def to_h()
		{ "key" => @key, "value" => @value }
	end
	
end

Auth::User.new_attr(:userdataset) do |user, from_storage|
	collection = WStorage::DistributedStorager.new(UserData, "#{user.data_dir}/userdata/%s/userdata.conf")
	collection.load_all if from_storage
	collection
end

end
