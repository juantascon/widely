wmodule :HTTP => [:FS, :Auth] do |mod|
	require "json.rb"
	require "adapter/mongreladapter.rb"
	require "adapter/webrickadapter.rb"
	require "dispatch.rb"
end
