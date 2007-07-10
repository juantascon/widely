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
		
		HTTPAPI::Dispatcher.register_wplugin(WPlugin.new("mongrel",
			"Mongrel plugin for HTTPAPI",
			mod.MODULE::MongrelAPI))
		HTTPStatic::Dispatcher.register_wplugin(WPlugin.new("mongrel",
			"Mongrel Plugin for HTTPStatic",
			mod.MODULE::MongrelStatic))
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
