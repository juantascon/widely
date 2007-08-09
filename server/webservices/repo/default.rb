module Repo

#
# Plugin manejador de repositorio por defecto
#

class Default
	
	def wplugin_init()
		raise StandardError, "abstract class"
	end
	
	METHODS = [ :create, :"repo_file?",
		:checkout, :status, :commit, :versions,
		:cat, :ls, :add, :delete, :move, :copy ]
	
	#
	# Define los metodos por defecto
	#
	METHODS.each do |m|
		define_method(m) do |*args|
			w_warn("called abstract method: #{self.class.name}.#{method_name}")
			return false, "invalid repository manager"
		end
	end
end

# Registra el plugin
Repository.register_wplugin(WPlugin.new("default", "Default Repo Manager Plugin", Default))

end
