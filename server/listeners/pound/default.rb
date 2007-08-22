#
# Plugin por defecto para el listener Pound
#

module Pound

module Default
	
	#
	# Inicia el archivo de configuracion
	#
	def wplugin_init()
		@config_file = Tempfile.new("pound.cfg")
		@started = false
		
		@config_file.print("Daemon 0\n",
			"ListenHTTP\n",
				"\tAddress 0.0.0.0\n",
				"\tPort #{@port}\n",
				"\txHTTP 2\n"
			)
	end
	
	#
	# Monta un servidor (backend)
	#
	# mount_point: el punto de montaje
	# hostname: el nombre del servidor
	# port: la ruta del servidor
	#
	def mount(mount_point, hostname, port)
		raise Exception, "imposible to mount, server already started" if @started
		
		#
		# Agrega una linea de definicion del backend en el archivo de
		# configuracion 
		#
		@config_file.print(
			"\tService\n",
				"\t\tURL \"^/#{mount_point}/*\"\n",
				"\t\tBackEnd\n",
					"\t\t\tAddress #{hostname}\n",
					"\t\t\tPort #{port}\n",
				"\t\tEnd\n",
			"\tEnd\n"
		)
	end
	
	#
	# Inicia el listener en un nuevo hilo
	#
	def run()
		raise Exception, "imposible to run, server already started" if @started
		
		# Cierra el archivo de configuracion
		@started = true
		@config_file.print("\nEnd")
		@config_file.close
		
		# Crea un archivo para monitorear su PID(Process ID)
		@pid_file = Tempfile.new("pound.pid")
		
		# Inicia el servidor como un proceso nuevo
		w_info "run(pound) => http://127.0.0.1:#{@port}"
		return Thread.new do
			Command.exec("#{POUND_HELPER}","-v", "-f", @config_file.path, "-p", @pid_file.path)
			self.stop
		end
	end
	
	#
	# Detiene el listener
	#
	def stop()
		w_info "STOP => pound"
		w_info "!!! WARNING !!!"
		w_info "!!! WIDELY MAIN SERVER STOPED !!!"
		
		#pid = File.new(@pid_file.path).read.to_i
		#Process.kill("TERM", pid)
	end
end

# Registra el plugin
Dispatcher.register_wplugin(WPlugin.new("default", "Default Pound (reverse proxy) Plugin", Default))

end
