#
# Modulo de manejo de descargas de archivos
#

wmodule :Download => [ :HTTPAPI, :WC, :Repos ] do |mod|
	begin
		mod.require "download.rb"
		mod.require "default.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end