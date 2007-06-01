#
# Modulo de listener webdav
#

wmodule :WebDav do |mod|
	begin
		require "webrick"
		
		mod.require "dispatcher.rb"
		mod.require "webdavhandler.rb"
		mod.require "default.rb"
		
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		
		false
	end
end
