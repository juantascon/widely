wmodule :FS => :Util do |mod|
	require "repository/repository.rb"
	require "repository/base.rb"
	require "repository/version.rb"
	
	require "fstree.rb"
	require "workingcopy.rb"
	require "project.rb"
end
