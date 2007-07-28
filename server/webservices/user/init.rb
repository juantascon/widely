#
# Modulo de manejo de usuarios
#

wmodule :User => :HTTPAPI do |mod|
	begin
		mod.require "extraattrs.rb"
		mod.require "wuser.rb"
		mod.require "userset.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
