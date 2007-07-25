#
# Modulo de manejo de Datos de usuario
#

wmodule :UserData => [ :Auth ] do |mod|
	begin
		mod.require "userdata.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
