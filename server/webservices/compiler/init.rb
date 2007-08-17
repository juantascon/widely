#
# Modulo de manejo de compilacion
#

wmodule :Compiler => [ :Auth, :WC ] do |mod|
	begin
		mod.require "genericcompiler.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
