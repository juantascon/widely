#
# Modulo de manejo de autenticacion (usuarios y sessiones)
#

wmodule :Auth => :HTTPAPI do |mod|
	begin
		#
		# Agrega las propiedades del modulo
		#
		$CONFIG.add(WConfig::NumericProperty.new("AUTH_KEY_SIZE", 256))
		$CONFIG.add(WConfig::StringProperty.new("AUTH_ADMIN_NAME", "admin"))
		$CONFIG.add(WConfig::StringProperty.new("AUTH_ADMIN_PASSWORD", "admin"))
		
		require "base64"
		
		mod.require "crypt.rb"
		mod.require "rand.rb"
		
		mod.require "users.rb"
		mod.require "sessions.rb"
		
		mod.require "webdavauth.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
