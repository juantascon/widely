module FS
class Repository < ForwardManager
	
	def initialize(manager_name=:default, *args)
		forward(manager_name, *args)
	end
	
end
end
