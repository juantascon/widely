#
# Modulo de manejo de versiones: SubVersion (Svn)
#
wmodule :Svn => :Repos do |mod|
	require "rexml/document.rb"
	mod.require "repository.rb"
	
	Repos::Repository.set_manager(:svn, mod._module_::Repository)
end
