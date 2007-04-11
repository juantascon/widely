module HTTP

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

#
# HTTP Response
#
class Resp
	attr_reader :status, :header, :body
	
	def initialize(status, header, body)
		@status = status
		@header = header
		@body = body
	end
	
	def self.new_json(obj)
		new(200, "text/json", obj.to_json)
	end
	
	def self.new_json_error(message)
		new(200, "text/json", {"error" => message}.to_json)
	end
end

end

