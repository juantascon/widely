module HTTP
module Dispatch
	def start()
		["INT", "TERM" ].each { |signal| trap(signal) { server.shutdown } }
		puts "=> Escuchando en http://127.0.0.1:#{port}"
		puts "=> Ctrl-C para terminar"
	end
end

