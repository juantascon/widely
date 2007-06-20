module Auth

class SessionSet < WCollection
	include Singleton
	
	def initialize
		super(Session)
	end
end

class Session
	
	attr_reader :id
	alias :collectable_key :id
	
	def initialize
		@id = Auth::Rand.rand_key
	end
	
end


class UserSession < Session
	
	class InvalidWC
		attr_reader :session_id
		
		def initialize(session_id)
			@session_id = session_id
		end
		
		def method_missing(m, *args)
			raise ArgumentError.new("#{@session_id}: session with empty wc use first auth::set_wc")
		end
	end
	
	
	attr_reader :user
	attr_accessor :wc
	
	def initialize(user)
		super()
		@user = user
		@wc = InvalidWC.new(@id)
		w_debug("new: #{@id} #{@user}")
	end
end


class AdminSession < Session
	
	def initialize(password)
		super()
		
		password = WUser::crypt(password)
		sys_password = $CONF.get("AUTH_ADMIN_PASSWORD").value
		
		if (password != sys_password)
			raise ArgumentError, "Invalid password"
		end
	end
	
end

end
