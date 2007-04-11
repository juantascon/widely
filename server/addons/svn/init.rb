#
# Modulo de manejo de versiones con SubVersion(Svn)
#
wmodule :Svn => :FS do |mod|
	require "rexml/document.rb"
	require "repositorysvn.rb"
	Repository.set_manager(:svn, mod._module_::RepositorySvn)
end
