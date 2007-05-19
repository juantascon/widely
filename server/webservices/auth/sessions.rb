module Auth
class Sessions < Collection
	
	include Singleton
	
	class Session
		include Collectable
		
		attr_reader :id, :user
		attr_writer :wc
		
		def initialize(user)
			@id = Auth::Rand.rand_key
			@user = user
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
