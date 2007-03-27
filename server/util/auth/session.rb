module Util
	class Session
		attr_reader :id, :user, :creation_time, :expiration_time
		
		def initialize(user)
			@creation_time = Time.now
			@expiration_time = @creation_time + (60 * 60 * 24 * 3) # 3 dias mas
			@user = user
			@id = Auth.rand_key()
		end
		
		def venced?
			return true if Time.now > @expiration_time
			return false
		end
	end
end
