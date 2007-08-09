#
# Modulo de manejo del servidor despachador
#

wmodule :Pound do |mod|
	begin
		raise Exception, "pound binary not found" if Command.exec("which", "pound").status != 0
		
		mod.require "dispatcher.rb"
		mod.require "default.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		false
	end
end
