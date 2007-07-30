#
# Modulo de manejo de autenticacion
#

wmodule :Auth => [ :HTTPAPI, :User ] do |mod|
	begin
		require "base64"
		
		$CONF.add_property("AUTH_KEY_SIZE", 256)
		$CONF.add_property("AUTH_ADMIN_PASSWORD", User::WUser.crypt("admin"))
		#sa1aY64JOY94w
		
		mod.require "rand.rb"
		mod.require "sessions.rb"
		
		mod.require "webdavauth.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
