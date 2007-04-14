# Como IO.popen pero tambien redirecciona la salida de error y permite cambiar el
# pwd del proceso
# 
# retorna una estructura con los siguientes campos:
# stdout: un string que contiene toda la salida de estandar del comando
# stderr: idem pero con la salida de error
# status: una estructura Process::Status con el estado de salida del proceso ejecutado
# 
# Ejemplo:
# Command.exec("ls /") #> 

class Command
	
	#
	# La estructura con la informacion de ejecucion de un commando
	#
	attr_reader :stdout, :stderr, :status
	
	def initialize(stdout, stderr, status)
		@stdout = stdout
		@stderr = stderr
		@status = status
	end
	
	#
	# Ejecuta el comando [cmd *args] cambiando el directorio actual de
	# trabajo(pwd) del proceso hijo
	#
	def self.exec_chpwd(pwd, cmd, *args)
		w_info("pwd: #{pwd} -- cmd: #{cmd} #{args.join(" ")}")
		
		#
		# Crea 2 tuberias (pipes) una para la salida estandar
		# y otro para la salida de error
		#
		r_out, w_out = IO.pipe
		r_err, w_err = IO.pipe
		
		fork do
			#
			# Proceso hijo:
			# 1. Cierra las tuberias en el lado de lectura
			# 2. Cambia al nuevo pwd
			# 3. Redirecciona la salida de error y estandar a las tuberias
			# 4. Ejecuta el comando
			#
			[r_out, r_err].each {|r| r.close}
			Dir.chdir(pwd)
			$stdout.reopen(w_out)
			$stderr.reopen(w_err)
			Kernel.exec(cmd, *args)
		end
		
		#
		# Proceso Padre:
		# 1. Cierra las tuberias en el lado de escritura
		# 2. Espera la ejecucion del proceso hijo
		# 3. retorna la estructura con la informacion de la ejecucion
		#
		[w_out, w_err].each {|w| w.close}
		Process.wait
		return new(r_out.read, r_err.read, $?.clone)
	end
	
	#
	# Llama a exec_chpwd con el directorio actual (para que no lo cambie)
	#
	def self.exec(cmd, *args)
		exec_chpwd(Dir.pwd, cmd, *args)
	end
	
end
