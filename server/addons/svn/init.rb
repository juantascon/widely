#
# Modulo de manejo de versiones: SubVersion (Svn)
#
wmodule :Svn => :Repos do |mod|
	begin
		require "rexml/document.rb"
		mod.require "repository.rb"
		
		Repos::Repository.set_manager(:svn, mod._module_::Repository)
		
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		false
	end
end
