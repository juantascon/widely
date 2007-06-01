#
# Modulo de manejo de Archivos Zip
#
wmodule :ZipFile => :Download do |mod|
	begin
		gem "rubyzip"
		require "zip/zip"
		Zip::ZipFile
		
		#mod.require "packer.rb"
		
		#Download::Download.set_manager(:zipfile, mod.MODULE::Packer)
		
		true
	rescue Exception => ex
		w_debug(ex)
		
		false
	end
end
