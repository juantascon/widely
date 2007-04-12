#
# Manejador de Copia de Trabajo
# TODO:
# new debe recibir un repository_id en lugar de un repository
# terminar status
#

module FS
class WorkingCopy < WebService
	
	# Registra esta clase como WebService
	webservice("wc")
	
	include FileUtils
	include FileTest

	attr_reader :wc_dir, :repository
	
	webservice_module_method :new => [ :wc_dir, :repository ]
	def initialize(wc_dir, repository)
		webservice_object
		@wc_dir = wc_dir
		@repository = repository
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
	webservice_method :checkout
	def checkout(version=versions.last)
		mkdir @wc_dir if ! directory? @wc_dir
		repository.checkout(@wc_dir, version)
	end

	
	def status()
		@repository.status(@wc_dir)
	end
	
	#
	# Hace commit de los cambios hechos en la copia
	# de trabajo al repositorio
	# log = la descripcion de los cambios
	#
	webservice_method :commit => :log
	def commit(log)
		@repository.commit(@wc_dir, log.to_s)
	end
	
	#
	# Retorna un Array arr de Repository::Version
	# siendo ar[0] -> la primera version
	# arr.size -> la cantidad de versiones
	# arr.last -> la ultima version
	#
	webservice_method :versions
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
	webservice_method :cat => :path
	def cat(path, version=nil)
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if ! File.absolute?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@wc_dir}/#{path}"
		if version
			return @repository.cat(path, version)
		else
			return false if ! file?(rpath)
			return File.new(rpath).read
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
	webservice_method :ls => :path
	def ls(path, version=nil)
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if ! File.absolute?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@wc_dir}/#{path}"
		if version
			return @repository.ls(path, version)
		else
			tree = FileTree.new
			Find.find(rpath) do |f|
				node_name = "#{Pathname.new(f).relative_path_from(Pathname.new(rpath)).to_s}"
				next if node_name == "."
				Find.prune if repository_file?(node_name)
				tree.add_with_parents("/#{node_name}", directory?(f))
			end
			return tree
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
	webservice_method :add => :path
	def add(path, as_dir=false)
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if (! File.absolute?(path)) or File.root?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@wc_dir}/#{path}"
		if ! exist?(rpath)
			mkdir(rpath) if as_dir
			touch(rpath) if ! as_dir
		end
		
		@repository.add(@wc_dir, path)
	end
	
	#
	# Elimina path de la copia de trabajo y
	# lo marca para ser eliminado del repositorio
	# en el proximo commit
	#
	# Si path es un directorio sera eliminado de
	# forma recursiva
	#
	webservice_method :delete => :path
	def delete(path)
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if (! File.absolute?(path)) or File.root?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@wc_dir}/#{path}"
		@repository.delete(@wc_dir, path) if exist?(rpath)
		rm_rf(rpath) if exist?(rpath)	
	end
	
	#
	# Mueve path_from a path_to en la copia de trabajo y
	# lo marca para ser movido en el repositorio
	# en el proximo commit
	#
	webservice_method :move => [ :path_from, :path_to ]
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
		
		rpath_from = "#{@wc_dir}/#{path_from}"
		rpath_to = "#{@wc_dir}/#{path_to}"
		if exist?(rpath_from)
			if directory?(rpath_to) or
				directory?(File.dirname(rpath_to))
				
				@repository.move(@wc_dir, path_from, path_to)
			else
				return false
			end
		end
		
		mv(rpath_from, rpath_to) if exist?(rpath_from)
	end
	
	#
	# Sobreescribe el contenido del archivo path en
	# la copia de trabajo
	#
	webservice_method :write => :path
	def write(path, content="")
		
		# path no puede ser una ruta relativa
		path = File.cleanpath(path)
		if ! File.absolute?(path) or repository_file?(path)
			w_warn("#{path}: invalid path")
			return false
		end
		
		rpath = "#{@wc_dir}/#{path}"
		return false if ! file?(rpath)
		
		file = File.new(rpath, "w")
		ret = file.write(content.to_s+"\n")
		file.fsync
		return ret
	end
end
end
