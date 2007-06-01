#
# Modulo de manejo de versiones: SubVersion (Svn)
#
wmodule :MongrelAdapter => [ :HTTPStatic, :HTTPAPI ] do |mod|
	begin
		# Mongrel require
		gem "mongrel"
		require "mongrel"
		
		mod.require "mongrelapi.rb"
		mod.require "mongrelstatic.rb"
		
		HTTPAPI::Dispatcher.register_wplugin(WPlugin.new("mongrel", mod.MODULE::MongrelAPI))
		HTTPStatic::Dispatcher.register_wplugin(WPlugin.new("mongrel", mod.MODULE::MongrelStatic))
		
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		
		false
	end
end
