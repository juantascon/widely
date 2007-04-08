wmodule :HTTP => [:FS, :Auth] do |mod|
	require "json.rb"
	require "adapters/base.rb"
	require "adapters/mongreladapter.rb"
	require "adapters/webrickadapter.rb"
	require "dispatch.rb"
end
