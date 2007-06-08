#
# Modulo de manejo de Datos de usuario
#

wmodule :UserData => [ :Auth, :HTTPAPI ] do |mod|
	begin
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
