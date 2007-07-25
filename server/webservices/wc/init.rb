#
# Modulo de manejo de copias de trabajo
#

wmodule :WC => [ :HTTPAPI, :Repo ] do |mod|
	begin
		mod.require "workingcopy.rb"
		mod.require "default.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
