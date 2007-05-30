module Auth

class UserSet < Collection
	
	include Singleton
	
	def initialize
		super
		add(User.new($CONFIG.get("AUTH_ADMIN_NAME").get_value, $CONFIG.get("AUTH_ADMIN_PASSWORD").get_value))
	end
	
	def get(name, password)
		user = super(name)
		
		return user if ( user ) and ( user.authenticate(password) )
		return nil
	end
	
end

class User
	
	attr_reader :uid, :config, :wcs, :repos
	attr_reader :collectable
	
	def initialize(uid, password)
		@uid = uid
		@password = Auth::Crypt.crypt(password)
		@wcs = Collection.new
		@repos = Collection.new
		
		@collectable = Collectable.new(self, @uid)
		w_debug("new: #{@collectable.to_s}")
	end
	
	def authenticate(password)
		( Auth::Crypt.crypt(password) == @password )
	end
		
	
	def data_dir
		File.cleanpath("#{$CONFIG.get("CORE_DATA_DIR").get_value}/#{@uid}")
	end
	
end

end
