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
	
	attr_reader :id, :user
	attr_accessor :wc
	alias :collectable_key :id
	
	def initialize(user)
		@id = Auth::Rand.rand_key
		@user = user
		@wc = InvalidWC.new(@id)
		w_debug("new: #{@id} #{@user}")
	end
	
end

end
