module Auth
class Sessions < Collection
	
	include Singleton
	
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
		
		include Collectable
		
		attr_reader :id, :user
		attr_writer :wc
		
		def initialize(user)
			@id = Auth::Rand.rand_key
			@user = user
			@wc = InvalidWC.new(@id)
		end
		
		def collectable_id
			@id
		end
		
		def wc
			@wc
		end
	end
	
	def create(user)
		save_o(Session.new(user))
	end
	
end
end
