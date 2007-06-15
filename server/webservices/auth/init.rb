#
# Modulo de manejo de autenticacion (usuarios y sessiones)
#

wmodule :Auth => :HTTPAPI do |mod|
	begin
		require "base64"
		
		$CONF.add_property("AUTH_KEY_SIZE", 256)
		$CONF.add_property("AUTH_ADMIN_PASSWORD", "sa1aY64JOY94w")
		
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
