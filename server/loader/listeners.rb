#
# Carga los listeners por defecto
#
$WIDELY_LISTENERS.push HTTPAPI::Dispatcher.new(7777)
$WIDELY_LISTENERS.push HTTPStatic::Dispatcher.new(7778)
$WIDELY_LISTENERS.push WebDav::Dispatcher.new(7779)

#
# Ejecuta cada listener en un hilo
#
$WIDELY_LISTENERS.each { |listener| $WIDELY_THREADS.push listener.run() }

#
# Atrapa las señales para que sean manejadas correctamente
#
["INT", "TERM" ].each { |signal| trap(signal) { $WIDELY_LISTENERS.each { |server| server.stop } } }
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
