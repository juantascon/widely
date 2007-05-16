#
# Modulo de manejo de versiones: SubVersion (Svn)
#
wmodule :Svn => :FS do |mod|
	require "rexml/document.rb"
	require "repository.rb"
	FS::Repository.set_manager(:svn, mod._module_::Repository)
end
