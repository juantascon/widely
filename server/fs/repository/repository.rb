module FS
module Repository
	class Repository < SimpleDelegator
		def initialize(type, *args)
			__setobj__(type.new(args))
		end
	end
end
end
