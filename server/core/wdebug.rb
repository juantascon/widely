module WDebug
	
	module Sev
		SEVS = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN)
		DEBUG = D = 0
		INFO = I = 1
		WARN = W = 2
		ERROR = E = 3
		FATAL = F = 4
		UNKNOWN = U = 5
	end
	
	class WE < Exception
		attr_reader :from, :severity, :message
		
		def initialize(severity, from, message)
			@from, @severity, @message = from.upcase, severity, message
			w_log(@severity, self.to_s)
		end
		
		def to_s()
			"[Exception][#{@from}]: #{@message}"
		end
	end
	
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
	
	def w_log(severity, m, back=1, &block)
		return true if severity < $WDEBUG_LEVEL
		
		m = if m.respond_to? :message; m.message; else m.to_s; end
		m = yield if block_given?
		severity = Sev::SEVS[severity] || Sev::SEVS[Sev::UNKNOWN]
		
		if caller_method(back)
			from = "#{self.class.name}.#{caller_method(back)}()"
		else
			from = "#{self.class.name}"
		end
		
		$WDEBUG_LOGGER_DEV.print("[%s] %s: %s\n" % [severity, from, m])
	end
	
	def w_debug(m, back=0, &block); w_log(Sev::D, m, 2+back, &block); end
	def w_info(m, back=0, &block); w_log(Sev::I, m, 2+back, &block); end
	def w_warn(m, back=0, &block); w_log(Sev::W, m, 2+back, &block); end
	def w_error(m, back=0, &block); w_log(Sev::E, m, 2+back, &block); end
	def w_fatal(m, back=0, &block); w_log(Sev::F, m, 2+back, &block); end
	def w_unknown(m, back=0, &block); w_log(Sev::U, m, 2+back, &block); end
	
	def we_debug(from, m); WE.new(Sev::D, from, m); end
	def we_info(from, m); WE.new(Sev::I, from, m); end
	def we_warn(from, m); WE.new(Sev::W, from, m); end
	def we_error(from, m); WE.new(Sev::E, from, m); end
	def we_fatal(from, m); WE.new(Sev::F, from, m); end
	def we_unknown(from, m); WE.new(Sev::U, from, m); end
	
end

class Object
	include WDebug
end

#module Kernel
#	DEFAULT_REQUIRE = method(:require)
#	def require(source)
#		w_debug("requiring: #{source}")
#		DEFAULT_REQUIRE.call(source)
#	end
#end
