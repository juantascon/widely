#
# Manejador de Copia de Trabajo
# TODO:
# terminar status()
#

module FS
class WorkingCopy
class Base
	
	METHODS = [:"repository_file?", :checkout, :status, :commit, :versions, :cat, :ls, :add, :delete, :move, :write]
	
	
	include FileUtils
	include FileTest
	
	@@WC = Repository::Version.new("-1")
	def self.WC; @@WC; end
	
	attr_reader :_self
	attr_reader :user, :name, :repository
	
	def initialize(_self)
		@_self = _self
		@user = @_self.user
		@name = @_self.name
		@repository = @_self.repository
		
		if File.basename(File.cleanpath(_self.dir)) != @name
			raise ArgumentError.new("#{@name}: invalid name:)")
		end
		
		mkdir_p @_self.dir if ! directory? @_self.dir
	end
	
	#
	# Verifica si un archivo hace parte del manejador de
	# versiones o si hace parte del sistema de archivos
	#
	def repository_file?(f)
		f = File.cleanpath("%wc_dir%/#{f}")
		
		#
		# Cada repositorio define files() como un metodo que
		# retorna un array de expresiones regulares o simplemente
		# strings.
		# El string especial %wc_dir% se entiende como
		# la ruta de la copia de trabajo
		#
		@repository.files.each do |exp|
			return true if exp === f
		end
		return false
	end
	
	#
	# Obtiene una copia de trabajo
	#
	def checkout(version=@@WC)
		version=versions.last if (! version || version.get == @@WC.get)
		
		
		return repository.checkout(@_self.dir, version)
	end

	
	def status()
		@repository.status(@_self.dir)
	end
	
	#
	# Hace commit de los cambios hechos en la copia
	# de trabajo al repositorio
	# log = la descripcion de los cambios
	#
	def commit(log)
		@repository.commit(@_self.dir, log.to_s)
	end
	
	#
	# Retorna un Array arr de Repository::Version
	# siendo ar[0] -> la primera version
	# arr.size -> la cantidad de versiones
	# arr.last -> la ultima version
	#
	def versions()
		@repository.versions()
	end
	
	#
	# Retorna el contenido del archivo path
	#
	# si se especifica version se mostrara la version
	# del repositorio, sino se mostrara la version
	# de la copia de trabajo
	#
	def cat(path, version=@@WC)
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if ! File.absolute?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@_self.dir}/#{path}"
		if ! version || version.get == @@WC.get
			return false if ! file?(rpath)
			return File.new(rpath).read
		else
			return @repository.cat(path, version)
		end
	end
	
	#
	# Retorna un FileTree recursivo con todas las entradas
	# de archivos desde path
	#
	# si se especifica version se mostrara la version
	# del repositorio, sino se mostrara la version
	# de la copia de trabajo
	#
	def ls(path, version=@@WC)
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if ! File.absolute?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@_self.dir}/#{path}"
		if ! version || version.get == @@WC.get
			tree = FileTree.new
			Find.find(rpath) do |f|
				node_name = "#{Pathname.new(f).relative_path_from(Pathname.new(rpath)).to_s}"
				next if node_name == "."
				Find.prune if repository_file?(node_name)
				tree.add_with_parents("/#{node_name}", directory?(f))
			end
			return tree
		else
			return @repository.ls(path, version)
		end
	end
	
	
	#
	# Agrega path a la copia de trabajo y
	# lo marca para ser agregado al repositorio
	# en el proximo commit
	#
	# si se especifica as_dir se creara como
	# directorio, sino como archivo regular
	#
	def add(path, as_dir=false)
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if (! File.absolute?(path)) or File.root?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@_self.dir}/#{path}"
		if ! exist?(rpath)
			mkdir(rpath) if as_dir
			touch(rpath) if ! as_dir
		end
		
		return @repository.add(@_self.dir, path)
	end
	
	#
	# Elimina path de la copia de trabajo y
	# lo marca para ser eliminado del repositorio
	# en el proximo commit
	#
	# Si path es un directorio sera eliminado de
	# forma recursiva
	#
	def delete(path)
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if (! File.absolute?(path)) or File.root?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@_self.dir}/#{path}"
		(ret = @repository.delete(@_self.dir, path)) if exist?(rpath)
		rm_rf(rpath) if exist?(rpath)
		
		return ret
	end
	
	#
	# Mueve path_from a path_to en la copia de trabajo y
	# lo marca para ser movido en el repositorio
	# en el proximo commit
	#
	def move(path_from, path_to)
		
		# path_from y path_to no pueden ser rutas relativas
		path_from = File.cleanpath(path_from)
		path_to = File.cleanpath(path_to)
		if (! File.absolute?(path_from)) or File.root?(path_from) or repository_file?(path_from)
			w_warn("#{path_from}: invalid path")
			return false
		end
		if ! File.absolute?(path_to) or repository_file?(path_to)
			w_warn("#{path_to}: invalid path")
			return false
		end
		
		rpath_from = "#{@_self.dir}/#{path_from}"
		rpath_to = "#{@_self.dir}/#{path_to}"
		if exist?(rpath_from)
			if directory?(rpath_to) or
				directory?(File.dirname(rpath_to))
				
				@repository.move(@_self.dir, path_from, path_to)
			else
				return false
			end
		end
		
		return mv(rpath_from, rpath_to) if exist?(rpath_from)
	end
	
	#
	# Sobreescribe el contenido del archivo path en
	# la copia de trabajo
	#
	def write(path, content)
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if ! File.absolute?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@_self.dir}/#{path}"
		return false if ! file?(rpath)
		
		file = File.new(rpath, "w")
		ret = file.write(content.to_s+"\n")
		file.fsync
		return ret
	end
	
end

#define el manejador por defecto y los metodos a delegar
set_manager(:default, Base)
set_methods(Base::METHODS)

end
end