wmodule :Auth => :HTTP do |mod|
	mod.require "crypt.rb"
	mod.require "rand.rb"
	
	mod.require "users.rb"
	mod.require "sessions.rb"
	mod.require "api.rb"
end
