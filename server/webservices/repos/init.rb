#
# Modulo de manejo de repòsitorios
#

wmodule :Repos => :HTTPAPI do |mod|
	begin
		mod.require "version.rb"
		mod.require "repository.rb"
		mod.require "default.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
	
end
