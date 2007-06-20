class WUser
	
	class Set < WStorage::DistributedStorager
		
		include Singleton
		
		def initialize
			super(User, "#{$WIDELY_DATA_DIR}/users/%s/user.conf")
			add(User.new("test", "test")) if ! get("test")
		end
		
		def get(user_id, password=nil)
			user = super(user_id)
			return user if (! password)
			return user if ( user ) and ( user.authenticate(password) )
			return nil
		end
		
	end
	
	class ExtraAttrs
		
		include Singleton
		
		def initialize
			@attrs_constructors = Hash.new
			@attrs_order = Array.new
		end
		
		def add(attr_name, &constructor_block)
			raise Exception, "constructor block not given" if ! block_given?
			
			@attrs_order.push(attr_name.to_sym)
			@attrs_constructors[attr_name.to_sym] = constructor_block
		end
		
		def initialize_attrs(user, from_storage)
			attrs = Hash.new
			@attrs_order.each do |attr_name|
				constructor_block = @attrs_constructors[attr_name]
				attrs[attr_name] = constructor_block.call(user, from_storage)
			end
			return attrs
		end
		
	end
	
	def self.crypt(str)
		return str.crypt("salt"+str)
	end
	
end


class WUser
	
	include WStorage::Storable
	
	attr_reader :user_id, :data_dir
	alias :collectable_key :user_id
	
	def method_missing(method_name, *args)
		return @extra_attrs[method_name.to_sym] if @extra_attrs[method_name.to_sym]
		raise NoMethodError, "undefined method `#{method_name}' for #{self}"
	end
	
	def initialize(user_id, password, from_storage=false)
		password = WUser::crypt(password) if ! from_storage
		
		@user_id = user_id
		@password = password
		
		@data_dir = "#{$WIDELY_DATA_DIR}/users/#{@user_id}/data_dir" if ! @data_dir
		
		raise wex_arg("name", @name, "(nice try)") if ! validate_id(@user_id)
		
		@extra_attrs = ExtraAttrs.instance.initialize_attrs(self, from_storage)
		
		w_debug("new: #{@user_id}")
	end
	
	def initialize_from_storage(data)
		user_id = data["user_id"]
		password = data["password"]
		
		initialize(user_id, password, true)
	end
	
	def to_h()
		{ "user_id" => @user_id, "password" => @password }
	end
	
	def authenticate(password)
		( WUser::crypt(password) == @password )
	end
	
end
