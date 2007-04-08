module Auth
class Users
	include Singleton

	def initialize
		@content = StorableHash.new
		@sessions = Hash.new
	end
	
	def add(user, password)
		@content[user] = Auth.crypt(password)
	end
	
	def remove(user)
		@content.delete(user)
	end
	
	def authenticate(user, password)
		return true if @content[user] == Auth.crypt(password)
		return false
	end
	
	def login(user, password)
		if Users.instance.authenticate(user, password)
			# Si no existe una session la crea y retorna el id
			@sessions[user] = new_session(user) if (! @sessions[user] or @sessions[user].venced?)
			return @sessions[user].id
		end
		return nil
	end
	
	def logout(user)
		@sessions.delete(user)
	end
end
end
