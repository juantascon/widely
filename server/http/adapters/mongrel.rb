module HTTP
module Adater
class MongrelAdapter
	require "rubygems"
	gem "mongrel"
	require "mongrel"

	class SimpleHandler < Mongrel::HttpHandler
		def process(request, response)
			response.start(200) do |head,out|
				head["Content-Type"] = "text/plain"
				out.write("hello!\n")
			end
		end
	end
	h = Mongrel::HttpServer.new("127.0.0.1", "3000")
	h.register("/test", SimpleHandler.new)
	h.register("/files", Mongrel::DirHandler.new("."))
	h.run.join

end
end
