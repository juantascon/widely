#
# Manejo de sessiones
#

module Auth

#
# La coleccion se sessiones
#

class SessionSet < WCollection
	include Singleton
	
	def initialize
		super(Session)
	end
end

#
# Define un tipo de session
#
class Session
	
	attr_reader :id
	alias :collectable_key :id
	
	def initialize
		# Crea el identificador de la session
		@id = Auth::Rand.rand_key
	end
end

#
# Define una session tipo usuario
#

class UserSession < Session
	
	#
	# Cuando el usuario no tiene una copia de trabajo asignada
	#
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
	
	#
	# Crea una session nueva
	#
	# user: el usuario de la session
	#
	def initialize(user)
		super()
		@user = user
		@wc = InvalidWC.new(@id)
		w_debug("new: #{@id} #{@user}")
	end
	
	#
	# Permite cambiar la clave del usuario
	#
	def change_password(password_old, password_new)
		return self.user.change_password(password_old, password_new)
	end
end

#
# Session tipo administrador
#

class AdminSession < Session
	
	#
	# Crea la session a partir de la clave de administrador
	#
	def initialize(password)
		super()
		
		# Obtiene la clave almacenada en el sistema
		password = User::WUser.crypt(password)
		sys_password = $CONF.get("AUTH_ADMIN_PASSWORD").value
		
		# La clave es correcta?
		if (password != sys_password)
			raise ArgumentError, "Invalid password"
		end
	end
	
	#
	# Cambia la clave de administrador
	#
	def change_password(password_old, password_new)
		if $CONF.get("AUTH_ADMIN_PASSWORD").value != User::WUser.crypt(password_old)
			return false, "Invalid Password"
		end
		
		$CONF.add_property("AUTH_ADMIN_PASSWORD", User::WUser.crypt(password_new))
		return true
	end
	
end

end
