#
# Modulo de manejo de versiones: SubVersion (Svn)
#
wmodule :Svn => :Repos do |mod|
	begin
		require "rexml/document.rb"
		mod.require "repository.rb"
		
		Repos::Repository.register_wplugin(WPlugin.new("svn", mod.MODULE::Repository))
		
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		
		false
	end
end
