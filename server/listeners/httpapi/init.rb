#
# Modulo de manejo de conecciones http API
#

wmodule :HTTPAPI do |mod|
	begin
		require "webrick.rb"
		require "json.rb"
		require "uri"
		
		mod.require "rq.rb"
		mod.require "resp.rb"
		mod.require "urlparser.rb"
		mod.require "webservicehandler.rb"
		
		mod.require "dispatcher.rb"
		mod.require "default.rb"
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
