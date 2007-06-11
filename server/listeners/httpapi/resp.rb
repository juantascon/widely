module HTTPAPI

#
# HTTP Response
#
class Resp
	attr_reader :status, :content_type, :body
	
	def initialize(status, content_type, body)
		@status = status
		@content_type = content_type
		@body = body
	end
	
	#
	# Status: Not Found
	#
	def self.new_not_found()
		new(404, "", "NOT FOUND A")
	end
	
	#
	# Status: MethodNotAllowed
	#
	def self.new_method_not_allowed()
		new(405, "", "METHOD NOT ALLOWED")
	end
	
	#
	# Status: OK
	#
	def self.new_html(data)
		new(200, "text/html", data)
	end
	
	#
	# Status: OK
	#
	def self.new_json(obj)
		new(200, "application/json", obj.to_json)
	end
	
	#
	# Status: Internal server Error
	#
	def self.new_error_json(message)
		new(500, "application/json", {"error" => message}.to_json)
	end
end

end
