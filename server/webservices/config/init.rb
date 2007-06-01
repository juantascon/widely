#
# Modulo de manejo de Configuraciones
#

wmodule :Config => [ :Auth, :HTTPAPI ] do |mod|
	begin
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		
		false
	end
end
