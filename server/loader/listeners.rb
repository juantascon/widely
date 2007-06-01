#
# Inicia los servidores cada uno en un hilo
#
servers_group = Array.new
threads_group = Array.new
[ HTTPAPI::Dispatcher.new(7777), HTTPStatic::Dispatcher.new(7778), WebDav::Dispatcher.new(7779) ].each do |s|
	servers_group.push(s)
	threads_group.push(s.run)
end

#
# Atrapa las señales para que sean manejadas correctamente
#
["INT", "TERM" ].each { |signal| trap(signal) { servers_group.each { |server| server.stop } } }
w_info ""
w_info " ================================ "
w_info " => Ctrl-C to stop the servers <= "
w_info " ================================= "
w_info ""


#
# Hace que el hilo principal espere a que
# los otros hilos terminen
#
threads_group.each { |t| t.join }
