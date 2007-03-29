module Kernel
	def caller_method(back=0)
		return $1 if /`(.*)'/.match(caller[back])
	end
	alias_method :method_name, :caller_method
	
	def caller_line(back=0)
		return $1 if /:([0-9])/.match(caller[back])
	end
	
	def caller_file(back=0)
		return $1 if /(.*):[0-9]/.match(caller[back])
	end
end

autoload(:Singleton, "singleton.rb")
autoload(:FileUtils, "fileutils.rb")
autoload(:SimpleDelegator, "delegate.rb")
autoload(:Pathname, "pathname.rb")
