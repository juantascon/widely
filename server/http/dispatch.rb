module HTTP
module Dispatch
	def start()
		server = nil
		
		[MongrelAdapter, WEBrickAdapter].each do |adapter|
			next if ! adapter.avaliable
			if ! server
				server = adapter.new() do |h|
				end
			end
		end
		
		["INT", "TERM" ].each { |signal| trap(signal) { server.stop } }
		puts "=> Escuchando en http://127.0.0.1:#{port}"
		puts "=> Ctrl-C para terminar"
	end
end

