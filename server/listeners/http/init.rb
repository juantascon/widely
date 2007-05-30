#
# Modulo de manejo de conecciones http
#
wmodule :HTTP do |mod|
	begin
		require "json.rb"
		
		mod.require "rq.rb"
		mod.require "resp.rb"
		mod.require "apihandler.rb"
		
		mod.require "adapters/base.rb"
		mod.require "adapters/mongreladapter.rb"
		mod.require "adapters/webrickadapter.rb"
		
		mod.require "dispatcher.rb"
		
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		
		false
	end
end
