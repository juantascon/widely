#
# Como IO.popen pero tambien redirecciona la salida de error y permite cambiar el
# pwd del proceso
#

class Command
	
	#
	# Representa un comando terminado
	#
	# pid: el id de proceso
	# stdout: un string que contiene toda la salida estandar del proceso hijo
	# stderr: idem pero con la salida de error
	# status: una estructura Process::Status con el estado de salida del proceso ejecutado
	#
	class Finished
		
		attr_reader :pid, :status, :stdout, :stderr
		
		def initialize(pid, status, stdout, stderr)
			@pid = pid
			@status = status
			@stdout = stdout
			@stderr = stderr
		end
		
	end
	
	#
	# Representa un comando en ejecucion
	#
	# pid: el id de proceso
	# stdout: un IO que representa la salida estandar del proceso hijo
	# stderr: idem pero con la salida de error
	#
	class Monitored
		
		attr_reader :pid, :stdout, :stderr
		
		def initialize(pid, stdout, stderr)
			@pid = pid
			@stdout = stdout
			@stderr = stderr
		end
		
		def wait()
			Process.waitpid(@pid)
			w_info("process #{@pid}: end")
			return Finished.new(@pid, $?.clone, @stdout.read, @stderr.read)
		end
		
	end
	
	#
	# Ejecuta el comando [cmd *args]
	# opcionalmente cambia el directorio actual de trabajo del proceso hijo
	# retorna una estructura Command::Monitored
	#
	def self.exec2(pwd, cmd, *args)
		#
		# Crea 2 tuberias (pipes) una para la salida estandar
		# y otro para la salida de error
		#
		r_out, w_out = IO.pipe
		r_err, w_err = IO.pipe
		
		pid = fork do
			#
			# Proceso hijo:
			# 1. Cierra las tuberias en el lado de lectura
			# 2. Cambia al nuevo pwd
			# 3. Redirecciona la salida de error y estandar a las tuberias
			# 4. Ejecuta el comando
			#
			[r_out, r_err].each {|r| r.close}
			Dir.chdir(pwd) if pwd
			$stdin.reopen(File.new("/dev/null"))
			$stdout.reopen(w_out)
			$stderr.reopen(w_err)
			Kernel.exec(cmd, *args)
		end
		
		#
		# Proceso Padre:
		# 1. Cierra las tuberias en el lado de escritura
		# 2. retorna una estructura que permite monitorear el proceso
		#
		[w_out, w_err].each {|w| w.close}
		
		w_info("cmd: #{cmd} #{args.join(" ")} -- pwd: #{pwd} pid: #{pid}")
		return Monitored.new(pid, r_out, r_err)
	end
	
	#
	# Ejecuta el comando [cmd *args] en el directorio actual
	#
	# para mas informacion ver exec2()
	#
	def self.exec(cmd, *args)
		exec2(nil, cmd, *args).wait
	end
	
end
