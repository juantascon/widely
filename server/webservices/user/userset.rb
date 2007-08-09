module User

#
# Coleccion de usuario
#

class UserSet < WStorage::DistributedStorager
	
	include Singleton
	
	def initialize
		super(WUser, "#{$WIDELY_DATA_DIR}/users/%s/user.conf")
	end
	
	#
	# Obtiene y autentica un usuario 
	#
	def get(user_id, password=nil)
		user = super(user_id)
		return nil if ! user
		
		return user if (! password)
		return user if ( user.authenticate(password) )
		return nil
	end
	
	#
	# Carga los atributos extra del usuario
	#
	def load_all_extra_attrs()
		self.each do |key, user|
			ExtraAttrs.instance.initialize_attrs(user, true)
		end
	end
	
	#
	# Almacena los atributos extra del usuario
	#
	def save_all_extra_attrs()
		self.each do |key, user|
			user.extra_attrs.each do |key, attr|
				attr.save_all if attr.respond_to? :save_all
			end
		end
	end
	
end
end
