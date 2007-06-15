#
# Modulo de manejo de versiones: SubVersion (Svn)
#
wmodule :Svn => :Repo do |mod|
	begin
		require "rexml/document.rb"
		mod.require "repository.rb"
		
		Repo::Repository.register_wplugin(WPlugin.new("svn", mod.MODULE::Repository))
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
