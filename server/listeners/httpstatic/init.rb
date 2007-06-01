#
# Modulo de manejo de conecciones http
#

wmodule :HTTPStatic do |mod|
	begin
		require "webrick"
		
		mod.require "dispatcher.rb"
		mod.require "default.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
