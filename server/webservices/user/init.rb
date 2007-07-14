#
# Modulo de manejo de usuarios
#

wmodule :User => :HTTPAPI do |mod|
	begin
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
