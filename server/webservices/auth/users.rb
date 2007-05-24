module Auth
class Users < Collection
	
	include Singleton
	
	class User
		
		include Collectable
		
		attr_reader :name, :password, :wcs, :repos
		
		def initialize(name, password)
			w_info("Username: #{name}")
			@name = name
			@password = Auth::Crypt.crypt(password)
			
			@wcs = Collection.new
			@repos = Collection.new
		end
		
		def data_dir
			File.cleanpath("#{$CONFIG.get(:CORE_DATA_DIR)}/#{@name}")
		end
		
		def collectable_id
			@name
		end
	end
	
	def create(user, password)
		save_o(User.new(user, password))
	end
	
	def get_o(user, password="")
		user = @__objects__[user]
		return nil if ! user
		
		return user if user.password == Auth::Crypt.crypt(password)
	end
	
	alias_method :authenticate, :get_o
	
	instance.create($CONFIG.get(:AUTH_ADMIN_NAME), $CONFIG.get(:AUTH_ADMIN_PASSWORD))
	
end
end
