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
	
	def process_path(path)
		if ( @repo.repo_file? path ) or ( ! File.absolute?(path) )
			w_warn("#{path}: invalid path")
			return false, false
		else
			return File.cleanpath(path), "#{@data_dir}/#{File.cleanpath(path)}"
		end
	end
	private :process_path
	
	
	#
	# Obtiene una copia de trabajo
	#
	def checkout(version=self.default_wc)
		version = versions[1].last if (! version || version.get == self.class.default_wc.get)
		
		return @repo.checkout(@data_dir, version)
	end

	
	def status()
		# TODO: terminar
		return @repo.status(@data_dir)
	end
	
	#
	# Hace commit de los cambios hechos en la copia
	# de trabajo al repositorio
	# log = la descripcion de los cambios
	#
	def commit(log)
		@repo.commit(@data_dir, log.to_s)
	end
	
	#
	# Retorna un Array arr de Repo::Version
	# siendo ar[0] -> la primera version
	# arr.size -> la cantidad de versiones
	# arr.last -> la ultima version
	#
	def versions()
		@repo.versions()
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
		return false, "invalid path: #{path}" if ! path
		
		if ( ! version ) || ( version.get == self.class.default_wc.get )
			return false, "invalid file: #{path}" if ! file?(rpath)
			return true, File.new(rpath).read
		else
			return @repo.cat(path, version)
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
		return false, "invalid path: #{path}" if ! path
		
		if ( ! version ) || ( version.get == self.class.default_wc.get )
			tree = FileTree.new
			Find.find(rpath) do |f|
				node_name = "#{Pathname.new(f).relative_path_from(Pathname.new(rpath)).to_s}"
				next if node_name == "."
				Find.prune if @repo.repo_file?(node_name)
				tree.add_with_parents("/#{node_name}", directory?(f))
			end
			return true, tree
		else
			return @repo.ls(path, version)
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
		return false, "invalid path: #{path}" if ! path or File.root?(path)
		return false, "#{path}: already exists" if exist?(rpath)
		
		mkdir(rpath) if as_dir
		touch(rpath) if ! as_dir
		
		return @repo.add(@data_dir, path)
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
		return false, "invalid path: #{path}" if ! path or File.root?(path)
		
		status, ret = @repo.delete(@data_dir, path)
		
		rm_rf(rpath) if exist?(rpath) and status
		
		return status, ret
	end
	
	#
	# Mueve path_from a path_to en la copia de trabajo y
	# lo marca para ser movido en el repositorio
	# en el proximo commit
	#
	def move(path_from, path_to)
		
		path_from, rpath_from = process_path(path_from)
		return false, "invalid path_from: #{path_from}" if ! path_from or File.root?(path_from)
		
		path_to, rpath_to = process_path(path_to)
		return false, "invalid path_to: #{path_to}" if ! path_to
		
		status, ret = @repo.move(@data_dir, path_from, path_to)
		
		rm_rf(rpath_from) if exist?(rpath_from) and status
		
		return status, ret
	end
	
	def copy(path_from, path_to)
		
		path_from, rpath_from = process_path(path_from)
		return false, "invalid path_from: #{path_from}" if ! path_from or File.root?(path_from)
		
		path_to, rpath_to = process_path(path_to)
		return false, "invalid path_to: #{path_to}" if ! path_to
		
		status, ret = @repo.copy(@data_dir, path_from, path_to)
		
		cp_rf(path_from, path_to) if exist?(rpath_to) and status
		
		return status, ret
	end
	
	#
	# Sobreescribe el contenido del archivo path en
	# la copia de trabajo
	#
	def write(path, content)
		path, rpath = process_path(path)
		return false, "invalid path: #{path}" if ! path
		return false, "invalid file: #{path}" if ! file?(rpath)
		
		begin
			file = File.new(rpath, "w")
			ret = file.write(content.to_s+"\n")
			file.fsync
		rescue Exception => ex
			return false, ex.message
		end
		
		return true, ret
	end
	
end

WorkingCopy.register_wplugin(WPlugin.new("default",  "Default WorkingCopy manager Plugin",Default))

end
