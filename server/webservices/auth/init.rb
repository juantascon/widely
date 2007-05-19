wmodule :Auth => :HTTP do |mod|
	require "crypt.rb"
	require "rand.rb"
	
	require "users.rb"
	require "sessions.rb"
	require "api.rb"
end
