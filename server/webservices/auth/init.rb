wmodule :Auth => :HTTP do |mod|
	begin
		mod.require "crypt.rb"
		mod.require "rand.rb"
		
		mod.require "users.rb"
		mod.require "sessions.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		false
	end
end
