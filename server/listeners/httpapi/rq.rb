module HTTPAPI

#
# HTTP Request
#
class RQ
	attr_reader :method, :path, :body 
	
	def initialize(method, path, body)
		@method = method
		@path = path
		@body = body
	end
	
	def to_json
		{"method" => method, "path" => path, "body" => body}.to_json
	end
end

end
