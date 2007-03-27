module Util
class Command
	# Como IO.popen pero tambien redirecciona la salida de error y permite cambiar el
	# pwd del proceso
	# 
	# retorna una estructura con los siguientes campos:
	# stdout: idem pero con la salida de error
	# stderr: un string que contiene toda la salida de error del comando
	# status: una estructura Process::Status con el estado del proceso ejecutado
	# 
	# Ejemplo:
	# Util::Command.exec("ls /") #> 
	
	attr_reader :stdout, :stderr, :status
		
	def initialize(stdout, stderr, status)
		@stdout = stdout
		@stderr = stderr
		@status = status
	end
	
	def self.exec_chpwd(pwd, cmd, *args)
		w_info("pwd: #{pwd} -- cmd: #{cmd} #{args.join(" ")}")
		
		r_out, w_out = IO.pipe #Pipe de salida estandar
		r_err, w_err = IO.pipe #Pipe de salida de error 
		
		fork do #Proceso hijo
			[r_out, r_err].each {|r| r.close}
			Dir.chdir(pwd)
			$stdout.reopen(w_out)
			$stderr.reopen(w_err)
			Kernel.exec(cmd, *args)
		end
		
		[w_out, w_err].each {|w| w.close}
		Process.wait
		return new(r_out.read, r_err.read, $?.clone)
	end

	def self.exec(cmd, *args)
		exec_chpwd(Dir.pwd, cmd, *args)
	end

end
end
