#
# Representa una respuesta HTTP
#
module HTTPAPI

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
	def self.new_not_found(path)
		w_debug("API: #{path}: NOT FOUND")
		new(404, "", "API #{path}: NOT FOUND")
	end
	
	#
	# Status: MethodNotAllowed
	#
	def self.new_method_not_allowed(method)
		w_debug("#{method}: METHOD NOT ALLOWED")
		new(405, "", "#{method}: METHOD NOT ALLOWED")
	end
	
	
	#
	# Content Type: json
	#
	def self.new_json(status, obj)
		new(status, "application/json", obj.to_json)
	end
	
	#
	# Status: Internal server Error
	#
	def self.new_json_ex(webservice, message)
		new_json(500, {
			"status" => "fail",
			"message" => message,
			"webservice" => webservice
		})
	end
	
	#
	# Status: OK
	#
	def self.new_json_fail(webservice, message)
		new_json(200, {
			"status" => "fail",
			"message" => message,
			"webservice" => webservice
		})
	end
	
	#
	# Status: OK
	#
	def self.new_json_ok(webservice, ret)
		new_json(200, {
			"status" => "ok",
			"obj" => ret,
			"webservice" => webservice
		})
	end
end

end
