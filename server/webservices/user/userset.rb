module User
class UserSet < WStorage::DistributedStorager
	
	include Singleton
	
	def initialize
		super(WUser, "#{$WIDELY_DATA_DIR}/users/%s/user.conf")
	end
	
	def get(user_id, password=nil)
		user = super(user_id)
		return nil if ! user
		
		return user if (! password)
		return user if ( user.authenticate(password) )
		return nil
	end
	
	def load_all_extra_attrs()
		self.each do |key, user|
			ExtraAttrs.instance.initialize_attrs(user, true)
		end
	end
	
end
end
