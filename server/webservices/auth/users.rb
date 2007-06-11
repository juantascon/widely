module Auth

class UserSet < Collection
	
	include Singleton
	
	def initialize
		super(User, File.cleanpath("#{$CONFIG.get("CORE_DATA_DIR").get_value}/users.yml"))
		add(User.new("test", "test"))
	end
	
	def get(user_id, password=nil)
		user = super(user_id)
		return user if (! password)
		return user if ( user ) and ( user.authenticate(password) )
		return nil
	end
end

class User
	
	USER_BASE_DIRNAME = "users"
	
	attr_reader :user_id, :data_dir
	attr_reader :reposet, :wcset, :dataset
	alias :collectable_key :user_id
	
	def initialize(user_id, password)
		@user_id = user_id
		@password = Auth::Crypt.crypt(password)
		
		initialize2
		
		w_debug("new: #{@user_id}")
	end
	
	def initialize2()
		@data_dir = File.cleanpath(
			"#{$CONFIG.get("CORE_DATA_DIR").get_value}/#{USER_BASE_DIRNAME}/#{@user_id}")
		
		@reposet = Collection.new(Repos::Repository, "#{@data_dir}/repos.yml")
		@wcset = Collection.new(WC::WorkingCopy, "#{@data_dir}/wcs.yml")
		@dataset = Collection.new(UserData::UserData, "#{@data_dir}/userdata.yml")
	end
	
	def to_h()
		{ "user_id" => @user_id, "password" => @password }
	end
	
	def load(data)
		@user_id = data["user_id"]
		@password = data["password"]
		
		initialize2
		
		@dataset.load
		@reposet.load
		@wcset.load
	end
	
	def authenticate(password)
		( Auth::Crypt.crypt(password) == @password )
	end
	
end

end
