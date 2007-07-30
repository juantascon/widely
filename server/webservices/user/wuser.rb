module User
class WUser
	
	include WStorage::Storable
	include FileUtils
	
	attr_reader :user_id, :data_dir, :extra_attrs
	
	alias :collectable_key :user_id
	
	def method_missing(method_name, *args)
		w_debug(method_name)
		return @extra_attrs[method_name.to_sym] if @extra_attrs[method_name.to_sym]
		raise NoMethodError, "undefined method `#{method_name}' for #{self}"
	end
	
	def initialize(user_id, password, from_storage=false)
		password = WUser.crypt(password) if ! from_storage
		
		@user_id = user_id
		@password = password
		@extra_attrs = Hash.new
		
		@data_dir = "#{$WIDELY_DATA_DIR}/users/#{@user_id}/data_dir" if ! @data_dir
		
		raise wex_arg("user_id", @user_id, "(nice try)") if ! validate_id(@user_id)
		
		ExtraAttrs.instance.initialize_attrs(self, false) if ! from_storage
	end
	
	def initialize_from_storage(data)
		user_id = data["user_id"]
		password = data["password"]
		w_debug("restoring object: USER[user_id:#{user_id} password:#{password}]")
		
		initialize(user_id, password, true)
	end
	
	def destroy()
		@extra_attrs.each { |a| a.destroy if a.respond_to? :destroy }
		
		rm_rf(File.dirname(@data_dir))
		UserSet.instance.delete_by_object(self)
	end
	
	def to_h()
		{ "user_id" => @user_id, "password" => @password }
	end
	
	def authenticate(password)
		( WUser.crypt(password) == @password )
	end
	
	def change_password(password_old, password_new)
		return false, "invalid old password" if ! self.authenticate(password_old)
		return false, "new password too short" if password_new.size <= 3
		
		@password = WUser.crypt(password_new)
		return true
	end
	
	def self.crypt(str)
		return str.crypt("salt"+str)
	end
	
end
end
