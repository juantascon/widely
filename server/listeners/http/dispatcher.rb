module HTTP
class Dispatcher
	#
	# TODO: agregar soporte para Adapters como addons
	#
	
	attr_reader :server, :port
	
	#
	# Busca entre los adaptadores disponibles para iniciarlo
	# y ponerlo a escuchar en @port
	#
	def initialize(port)
		@port = port
		
		[Adapters::MongrelAdapter, Adapters::WEBrickAdapter].each do |adapter|
		#[Adapters::WEBrickAdapter, Adapters::MongrelAdapter].each do |adapter|
			next if ! adapter.avaliable
			break if @server
			
			@server = adapter.new(@port)
			
			@server.set_file_handler("/gui/", $WIDELY_HOME_GUI)
			@server.set_file_handler("/qooxdoo-sdk/", "#{$WIDELY_HOME}/../qooxdoo-0.7-beta1-sdk/")
			@server.set_file_handler("/doc/", $WIDELY_HOME_DOC)
			@server.set_proc_handler("/api/") { |rq| APIHandler.process_rq(rq) }
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
