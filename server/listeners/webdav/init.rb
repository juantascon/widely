#
# Modulo de manejo de conecciones WebDAV
#

wmodule :WebDav do |mod|
	begin
		require "webrick"
		
		mod.require "dispatcher.rb"
		mod.require "webdavhandler.rb"
		mod.require "default.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
