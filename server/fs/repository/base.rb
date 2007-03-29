# Esta clase es solo una clase abstracta de las que los modulos
# de manejo de versiones (ej: cvs, svn, git, etc) deben heredar
# y redefinir estos metodos

module FS
module Repository
	class Base
		[:create, :delete, :checkout, :commit, :status,
		:file_add, :file_delete, :file_move, :file_cat,
		:dir_create, :dir_list, :version_list ].each do |m|
		 	define_method(m) do |*args|
		 		w_warn("called abstract method: #{self.class.name}.#{method_name}")
		 	end
		end
	end
end
end
