module WebDav
class Dispatcher
	
	attr_reader :server, :port
	
	#
	# Busca entre los adaptadores disponibles para iniciarlo
	# y ponerlo a escuchar en @port
	#
	def initialize(port)
		@port = port
		
		[Adapters::WEBrickAdapter].each do |adapter|
			next if ! adapter.avaliable
			break if @server
			
			@server = adapter.new(@port)
			
			@server.set_webdav_handler("/data/", $CONFIG.get(:CORE_DATA_DIR))
		end
	end
	
	#
	# Inicia el servidor
	#
	def start()
		w_info "[#{self.class.name}] => http://127.0.0.1:#{port}"
		return Thread.new { @server.start }
	end
	
	#
	# Termina el servidor
	#
	def stop()
		w_info "[#{self.class.name}]"
		return @server.stop
	end
	
end
end
