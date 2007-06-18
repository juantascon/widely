#
# TODO: si en un listener se define el campo host, no deberia crearse aqui sino tenerlo
# en cuenta al montarlo en Pound
#


#
# Inicia la configuracion de los listeners
#
$CONF_LISTENERS = WConfig.new("#{$WIDELY_DATA_DIR}/listeners.conf",
	WConfig::Property.new("main", { "port"=>7777, "manager"=>"default" }),
	WConfig::Property.new("backends",
		{ "qooxdoo"=>"listener_static",
		"gui"=>"listener_static",
		"doc"=>"listener_static",
		"api"=>"listener_api",
		"data"=>"listener_webdav"}),
	WConfig::Property.new("listeners",
		{ "listener_api" => {"type"=>"httpapi", "port"=>3401, "manager"=>"default"},
		"listener_static" => {"type"=>"httpstatic", "port"=>3402, "manager"=>"default"},
		"listener_webdav" => {"type"=>"webdav", "port"=>3403, "manager"=>"default_auth"}}))

#
# Interpreta la informacion de configuracion de
# los listeners
#
begin
	retries = 0 if ! retries
	
	config = $CONF_LISTENERS
	config.load_all() if retries == 0
	
	retries += 1
	
	main = config.get("main").value
	$WIDELY_LISTENERS["main"] = Pound::Dispatcher.new(main["port"], main["manager"]) if main
	
	config.get("listeners").value.each do |name, listener|
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
			else raise wex_invalid("listener type", type)
		end
	end
	
	config.get("backends").value.each do |name, listener_name|
		listener = $WIDELY_LISTENERS[listener_name]
		listener.mount_backend(name)
		
		$WIDELY_LISTENERS["main"].mount(name, "127.0.0.1", listener.port) if main
	end
	
rescue Exception => ex
	w_info("invalid listeners config file: #{config.config_file}")
	w_info(ex)
	
	config.restore_to_default
	retry if retries < 2
end


#
# Ejecuta cada listener en un hilo y espera
# hasta que se terminen de crear
#
$WIDELY_LISTENERS.each { |name, listener| $WIDELY_THREADS.push listener.run() }
sleep(2)

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
