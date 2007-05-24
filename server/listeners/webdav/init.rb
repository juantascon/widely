wmodule :WebDav do |mod|
	begin
		require "webrick"
		
		mod.require "base.rb"
		mod.require "webrick/webrickadapter.rb"
		mod.require "webrick/webdavhandler.rb"
		
		mod.require "dispatcher.rb"
		
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		false
	end
end
