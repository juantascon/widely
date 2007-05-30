module Auth

class SessionSet < Collection
	include Singleton
	
	def initialize
		super
	end
end

class Session
	
	class InvalidWC
		attr_reader :session_id
		
		def initialize(session_id)
			@session_id = session_id
		end
		
		def method_missing(m, *args)
			raise ArgumentError.new("#{@session_id}: session with empty wc use first auth::set_wc")
		end
	end
	
	attr_reader :id, :user, :collectable
	attr_accessor :wc
	
	def initialize(user)
		@id = Auth::Rand.rand_key
		@user = user
		@wc = InvalidWC.new(@id)
		
		@collectable = Collectable.new(self, @id)
		w_debug("new: #{@collectable.to_s}")
	end
	
end

end
