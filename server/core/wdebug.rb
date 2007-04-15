module WDebug
	
	#
	# Este modulo define la severidad de los mensajes y
	# los excepciones
	#
	module Sev
		SEVS = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN)
		DEBUG = D = 0
		INFO = I = 1
		WARN = W = 2
		ERROR = E = 3
		FATAL = F = 4
		UNKNOWN = U = 5
	end
	
	#
	# Define hacia donde se mandan los mensajes de depuracion
	# y que tan severos son los mensajes a tener en cuenta
	#
	$WDEBUG_LOGGER_DEV = STDERR
	$WDEBUG_LEVEL = Sev::DEBUG
	
	def WDebug.initialize(logger_dev, level)
		if logger_dev.kind_of? IO
			$WDEBUG_LOGGER_DEV = logger_dev
		end
		
		if Sev::SEVS[level]
			$WDEBUG_LEVEL = level
		end
	end
	
	
	#
	# El metodo principal
	# es utilizado para imprimir los mensajes dependiendo de la
	# severidad y del dispositivo de salida
	#
	def w_log(severity, m, back=1, &block)
		return true if severity < $WDEBUG_LEVEL
		
		m = if m.respond_to? :message; m.message; else m.to_s; end
		m = block.call if block_given?
		severity = Sev::SEVS[severity] || Sev::SEVS[Sev::UNKNOWN]
		
		if caller_method(back)
			from = "#{self.class.name}.#{caller_method(back)}()"
		else
			from = "#{self.class.name}"
		end
		
		$WDEBUG_LOGGER_DEV.print("[%s] %s: %s\n" % [severity.to_s, from.to_s, m.to_s])
	end
	
	#
	# Estos metodos son muy utiles y comodos
	#
	# Para mensajes:
	def w_debug(m, back=0, &block); w_log(Sev::D, m, 2+back, &block); end
	def w_info(m, back=0, &block); w_log(Sev::I, m, 2+back, &block); end
	def w_warn(m, back=0, &block); w_log(Sev::W, m, 2+back, &block); end
	def w_error(m, back=0, &block); w_log(Sev::E, m, 2+back, &block); end
	def w_fatal(m, back=0, &block); w_log(Sev::F, m, 2+back, &block); end
	def w_unknown(m, back=0, &block); w_log(Sev::U, m, 2+back, &block); end
		
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
