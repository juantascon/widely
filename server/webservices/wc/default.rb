#
# Manejador de Copia de Trabajo
#

module WC
module Default
	
	include FileUtils
	include FileTest
	
	def wplugin_init()
		mkdir_p @data_dir if ! directory? @data_dir
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
	
	def process_path(path)
		if ( repository_file? path ) or ( ! File.absolute?(path) )
			w_warn("#{path}: invalid path")
			return false, false
		else
			return File.cleanpath(path), "#{@data_dir}/#{File.cleanpath(path)}"
		end
	end
	
	
	#
	# Obtiene una copia de trabajo
	#
	def checkout(version=self.default_wc)
		version=versions.last if (! version || version.get == self.class.default_wc.get)
		
		return repository.checkout(@data_dir, version)
	end

	
	def status()
		@repository.status(@data_dir)
	end
	
	#
	# Hace commit de los cambios hechos en la copia
	# de trabajo al repositorio
	# log = la descripcion de los cambios
	#
	def commit(log)
		@repository.commit(@data_dir, log.to_s)
	end
	
	#
	# Retorna un Array arr de Repo::Version
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
	def cat(path, version=self.default_wc)
		
		path, rpath = process_path(path)
		return false if ! path
		
		if ( ! version ) || ( version.get == self.class.default_wc.get )
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
	def ls(path, version=self.default_wc)
		
		path, rpath = process_path(path)
		return false if ! path
		
		if ( ! version ) || ( version.get == self.class.default_wc.get )
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
		
		path, rpath = process_path(path)
		return false if ! path or File.root?(path)
		
		if ! exist?(rpath)
			mkdir(rpath) if as_dir
			touch(rpath) if ! as_dir
		end
		
		return @repository.add(@data_dir, path)
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
		
		path, rpath = process_path(path)
		return false if ! path or File.root?(path)
		
		(ret = @repository.delete(@data_dir, path)) if exist?(rpath)
		rm_rf(rpath) if exist?(rpath)
		
		return ret
	end
	
	#
	# Mueve path_from a path_to en la copia de trabajo y
	# lo marca para ser movido en el repositorio
	# en el proximo commit
	#
	def move(path_from, path_to)
		
		path_from, rpath_from = process_path(path_from)
		return false if ! path_from or File.root?(path_from)
		
		path_to, rpath_to = process_path(path_to)
		return false if ! path_to
		
		return false if ! exist?(rpath_from)
		
		if directory?(rpath_to) or directory?(File.dirname(rpath_to))
			ret = @repository.move(@data_dir, path_from, path_to)
			
			if ret and exist?(rpath_from)
				if exist?(rpath_to)
					rm_rf(rpath_from)
				else
					mv(rpath_from, rpath_to)
				end
			end
			
			return ret
		end
	end
	
	def copy(path_from, path_to)
		
		path_from, rpath_from = process_path(path_from)
		return false if ! path_from or File.root?(path_from)
		
		path_to, rpath_to = process_path(path_to)
		return false if ! path_to
		
		return false if ! exist?(rpath_from)
		
		if directory?(rpath_to) or directory?(File.dirname(rpath_to))
			ret = @repository.copy(@data_dir, path_from, path_to)
			
			if ret and ! exist?(rpath_to)
				cp_rf(path_from, path_to)
			end
			
			return ret
		end
	end
	
	#
	# Sobreescribe el contenido del archivo path en
	# la copia de trabajo
	#
	def write(path, content)
		
		path, rpath = process_path(path)
		return false if ! path
		
		return false if ! file?(rpath)
		
		file = File.new(rpath, "w")
		ret = file.write(content.to_s+"\n")
		file.fsync
		
		return ret
	end
	
end

WorkingCopy.register_wplugin(WPlugin.new("default",  "Default WorkingCopy manager Plugin",Default))

end
