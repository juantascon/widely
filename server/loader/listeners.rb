#
# TODO: si en un listener se define el campo host, no deberia crearse aqui sino tenerlo
# en cuenta al montarlo en Pound
#

#
# Carga los listeners definidos en el archivo de configuracion
#
listeners_file = $CONFIG.get("CORE_LISTENERS_CONFIG_FILE").get_value

begin
	config = YAML::load(File.new( listeners_file ))
	main = config["main"]
	
	config["listeners"].each do |name, listener|
		type = listener["type"]
		port = listener["port"]
		manager = listener["manager"]
		host = listener["host"]
		
		$WIDELY_LISTENERS[name] = case type
			when "httpapi"
				 HTTPAPI::Dispatcher.new(port, manager)
			when "httpstatic"
				HTTPStatic::Dispatcher.new(port, manager)
			when "webdav"
				WebDav::Dispatcher.new(port, manager)
			else raise Exception, "invalid listener type: #{type}"
		end
	end
	
	$WIDELY_LISTENERS["main"] = Pound::Dispatcher.new(main["port"], main["manager"]) if main
	
	config["backends"].each do |name, listener_name|
		listener = $WIDELY_LISTENERS[listener_name]
		listener.mount_backend(name)
		
		$WIDELY_LISTENERS["main"].mount(name, "127.0.0.1", listener.port) if main
	end
	
rescue Exception => ex
	w_info("invalid listeners config file: #{listeners_file}")
	w_info(ex)
end


#
# Ejecuta cada listener en un hilo
#
$WIDELY_LISTENERS.each { |name, listener| $WIDELY_THREADS.push listener.run() }

#
# Atrapa las señales para que sean manejadas correctamente
#
["INT", "TERM" ].each { |signal| trap(signal) { $WIDELY_LISTENERS.each { |name, listener| listener.stop } } }
w_info ""
w_info " ================================ "
w_info " => Ctrl-C to stop the servers <= "
w_info " ================================ "
w_info ""


#
# Hace que el hilo principal espere a que
# los otros hilos terminen
#
$WIDELY_THREADS.each { |t| t.join }
