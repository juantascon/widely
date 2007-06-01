#
# Modulo de manejo de Configuraciones
#

wmodule :Config => [ :Auth, :HTTPAPI ] do |mod|
	begin
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
