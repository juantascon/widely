wmodule :HTTP do |mod|
	require "json.rb"
	
	mod.require "rq.rb"
	mod.require "resp.rb"
	mod.require "adapters/base.rb"
	mod.require "adapters/mongreladapter.rb"
	mod.require "adapters/webrickadapter.rb"
	
	mod.require "dispatcher.rb"
end
