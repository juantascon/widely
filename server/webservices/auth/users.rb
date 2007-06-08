module Auth

class UserSet < Collection
	
	include Singleton
	
	def initialize
		super()
		add(User.new($CONFIG.get("AUTH_ADMIN_NAME").get_value, $CONFIG.get("AUTH_ADMIN_PASSWORD").get_value))
	end
	
	def get(name, password)
		user = super(name)
		
		return user if ( user ) and ( user.authenticate(password) )
		return nil
	end
	
end

class User
	
	attr_reader :uid, :data_dir
	attr_reader :wcset, :reposet, :dataset
	alias :collectable_key :uid
	
	def initialize(uid, password)
		@uid = uid
		@data_dir = File.cleanpath("#{$CONFIG.get("CORE_DATA_DIR").get_value}/#{@uid}")
		
		@password = Auth::Crypt.crypt(password)
		
		@wcset = Collection.new
		@reposet = Collection.new
		@dataset = Collection.new
		
		w_debug("new: #{@uid}")
	end
	
	def authenticate(password)
		( Auth::Crypt.crypt(password) == @password )
	end
	
end

end
