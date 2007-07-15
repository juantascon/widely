#
# Modulo de manejo de usuarios
#

wmodule :User => [ :Auth, :HTTPAPI ] do |mod|
	begin
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
