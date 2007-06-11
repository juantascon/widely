module Pound

module Default
	
	def init_server()
		@config_file = Tempfile.new("pound.cfg")
		@started = false
		
		@config_file.print("Daemon 0\n",
			"ListenHTTP\n",
				"\tAddress 0.0.0.0\n",
				"\tPort #{@port}\n",
				"\txHTTP 2\n"
			)
	end
	
	def mount(mount_point, hostname, port)
		raise Exception, "imposible to mount, server already started" if @started
		@config_file.print(
			"\tService\n",
				"\t\tURL \"/#{mount_point}/*\"\n",
				"\t\tBackEnd\n",
					"\t\t\tAddress #{hostname}\n",
					"\t\t\tPort #{port}\n",
				"\t\tEnd\n",
			"\tEnd\n"
		)
	end
	
	def run()
		raise Exception, "imposible to run, server already started" if @started
		@started = true
		@config_file.print("\nEnd")
		@config_file.close
		@pid_file = Tempfile.new("pound.pid")
		
		w_info "run(pound) => http://127.0.0.1:#{@port}"
		return Thread.new do
			Command.exec("pound","-f", @config_file.path, "-p", @pid_file.path)
		end
	end
	
	def stop()
		w_info "stop(pound) => http://127.0.0.1:#{@port}"
		#pid = File.new(@pid_file.path).read.to_i
		#Process.kill("TERM", pid)
	end
end

Dispatcher.register_wplugin(WPlugin.new("default", Default))

end
