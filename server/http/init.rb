wmodule :HTTP do |mod|
	require "webservice.rb"
	require "rq-resp.rb"

	require "adapters/base.rb"
	require "adapters/mongreladapter.rb"
	require "adapters/webrickadapter.rb"
	
	require "dispatch.rb"
end

