module HTTP
module Dispatch
	def start(port)
		server = nil
		
		[Adapters::MongrelAdapter, Adapters::WEBrickAdapter].each do |adapter|
			next if ! adapter.avaliable
			if ! server
				server = adapter.new(port) do |h|
					if h["method"] != "POST"
						return { "error" => "try with POST instead of #{h["method"]}" }
					end
					
				end
			end
		end
		
		["INT", "TERM" ].each { |signal| trap(signal) { server.stop } }
		puts "=> Escuchando en http://127.0.0.1:#{port}"
		puts "=> Ctrl-C para terminar"
		server.start
	end
	module_function :start
end
end

