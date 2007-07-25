#
# Modulo de manejo de usuarios
#

wmodule :WUser => :HTTPAPI do |mod|
	begin
		mod.require "extraattrs.rb"
		mod.require "user.rb"
		mod.require "userset.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
