wmodule :Svn => :FS do |mod|
	require "rexml/document.rb"
	require "repositorysvn.rb"
	Repository::Repository.set_manager(:svn, mod._module_::RepositorySvn)
end
