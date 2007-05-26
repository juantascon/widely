wmodule :Download => [ :WC, :Repos ] do |mod|
	begin
		mod.require "download.rb"
		mod.require "base.rb"
		mod.require "api.rb"
		
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		false
	end
end
