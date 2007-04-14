wmodule :FS => :HTTP do |mod|
	require "repository/version.rb"
	require "repository/base.rb"
	require "repository/repository.rb"
	require "repository/api.rb"
	
	require "workingcopy/workingcopy.rb"
	require "workingcopy/api.rb"
end
