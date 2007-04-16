wmodule :HTTP do |mod|
	require "json.rb"
	
	require "rq.rb"
	require "resp.rb"
	require "adapters/base.rb"
	require "adapters/mongreladapter.rb"
	require "adapters/webrickadapter.rb"
	
	require "dispatcher.rb"
end

