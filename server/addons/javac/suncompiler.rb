#
# Modulo de compilacion del lenguajes java
# utiliza una interfaz con el programa javac de sun
#

module JavaC

module SunCompiler
	
	#
	# Compila un archivo fuente de java (.java)
	# wc: la copia de trabajo donde se encuentra el archivo fuente
	# path: la localizacion del archivo dentro de la copia de trabajo
	#
	def compile(wc, path)
		
		path = File.cleanpath(path)
		
		if ( ! File.absolute?(path) ) or
			( ! File.exist? File.cleanpath("#{wc.data_dir}/#{path}") )
			return false, "invalid File: #{path}"
		end
		
		cmd = Command.exec2(wc.data_dir, "javac", ".#{path}")
		cmd = cmd.wait
		
		status = cmd.status.exitstatus
		
		case status
			# Compilo con exito
			when 0
				return true
			
			# Errores de compilacion
			when 1
				return false, cmd.stderr
			
			# Error en los argumentos de javac
			when 2
				return false, "Invalid compiler options: Oops please report this bug to admin"
			
			# Aqui nunca deberia llegar
			else
				return false, "#{status}: Oops please report this bug to admin"
		end
	end
	
end

end
