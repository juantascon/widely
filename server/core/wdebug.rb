module WDebug
	
	$WDEBUG_LAST_OBJECT
	
	#
	# Este modulo define la severidad de los mensajes y
	# las excepciones
	#
	module Sev
		SEVS = %w(Debug Info Warn Error Fatal Unknown)
		DEBUG = D = 0
		INFO = I = 1
		WARN = W = 2
		ERROR = E = 3
		FATAL = F = 4
		UNKNOWN = U = 5
	end
	
	#
	# Define hacia donde se mandan los mensajes de depuracion
	# Por defecto hacia STDERR
	#
	WDEBUG_LOGGER = STDERR
	WDEBUG_LEVEL = Sev::DEBUG
	
	#
	# El metodo principal
	# es utilizado para imprimir los mensajes dependiendo de la
	# severidad y del dispositivo de salida
	#
	def w_log(severity, m, back=1, &block)
		return true if severity < WDEBUG_LEVEL
		
		if $WDEBUG_LAST_OBJECT != self
			WDEBUG_LOGGER.print(">> #{self.class.name} (#{sprintf("0x%x", self.object_id.abs)}):\n")
			$WDEBUG_LAST_OBJECT = self
		end
		
		#from = "#{self.class.name}"
		#from = "#{from}.#{caller_method(back)}()" if caller_method(back)
		from = "#{caller_method(back)}(): " if caller_method(back)
		severity = Sev::SEVS[severity] || Sev::SEVS[Sev::UNKNOWN]
		
		begin
			m = block.call if block_given?
		rescue Exception => block_ex
			m = block_ex
		end
		
		case m
			when Exception
				WDEBUG_LOGGER.print " [#{m.class.name}]: #{m.message}"
				WDEBUG_LOGGER.print " [BACKTRACE]: BEGIN\n"
				WDEBUG_LOGGER.print " \t#{m.backtrace.join("\n\t")}\n"
				WDEBUG_LOGGER.print " [BACKTRACE]: END\n"
			else
				#WDEBUG_LOGGER.print "[#{severity}] #{from}: #{m}\n"
				WDEBUG_LOGGER.print " [#{severity}] #{from}#{m}\n"
		end
		
		WDEBUG_LOGGER.flush
	end
	
	#
	# Estos metodos son muy utiles y comodos
	# Para mensajes:
	#
	def w_debug(m, back=0, &block); w_log(Sev::D, m, 2+back, &block); end
	def w_info(m, back=0, &block); w_log(Sev::I, m, 2+back, &block); end
	def w_warn(m, back=0, &block); w_log(Sev::W, m, 2+back, &block); end
	def w_error(m, back=0, &block); w_log(Sev::E, m, 2+back, &block); end
	def w_fatal(m, back=0, &block); w_log(Sev::F, m, 2+back, &block); end
	def w_unknown(m, back=0, &block); w_log(Sev::U, m, 2+back, &block); end
	
	def w_debugx(m, back=0, &block)
		w_debug("X"*70)
		w_debug(m, back, &block)
		w_debug("X"*70)
		sleep(2)
	end
	
	def wex_invalid(klass, obj, msg=nil); Exception.new("Invalid #{klass}: #{obj} #{msg}"); end
	def wex_arg(argname, arg, msg=nil); ArgumentError.new("Invalid Argument #{argname}: #{arg} #{msg}"); end
end

#
# Incluye los metodos dentro del entorno principal
#
class Object
	include WDebug
end

#
# Redefine la funcion require() permitiendo hacer un seguimiento
# de los archivos que se cargan en el sistema
#
#module Kernel
#	DEFAULT_REQUIRE = method(:require)
#	def require(source)
#		w_debug("requiring: #{source}")
#		DEFAULT_REQUIRE.call(source)
#	end
#end
