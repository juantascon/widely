#
# Modulo de manejo de Archivos Zip
#
wmodule :ZipFile => :Download do |mod|
	begin
		gem "rubyzip"
		require "zip/zip"
		Zip::ZipFile
		
		#mod.require "packer.rb"
		
		#Download::Download.set_manager(:zipfile, mod._module_::Packer)
		
		true
	rescue Exception => ex
		w_debug("Exception: #{ex.message}")
		w_debug(ex.backtrace.join("\n\t"))
		false
	end
end
