#
# Modulo de Compilacion de Java
#
wmodule :JavaC => :Compiler do |mod|
	begin
		mod.require "suncompiler.rb"
		
		Compiler::GenericCompiler.register_wplugin(WPlugin.new(
			"javac",
			"Sun javac plugin for Compiler support",
			mod.MODULE::SunCompiler))
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
