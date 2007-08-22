#
# Modulo de manejo del servidor despachador
#

wmodule :Pound do |mod|
	begin
		mod.require "dispatcher.rb"
		mod.require "default.rb"
		
		Pound::Default.class_eval "POUND_HELPER = \"#{mod.base_dir}/helper/pound\""
		
		true
	rescue Exception => ex
		w_debug(ex)
		false
	end
end
