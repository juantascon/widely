wmodule :WC => [:HTTP, :Repos] do |mod|
	mod.require "workingcopy.rb"
	mod.require "base.rb"
	mod.require "api.rb"
end
