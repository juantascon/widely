#
# Manejo de un repositorio con subversion(svn)
#

module Svn
module Repository
	
	include FileUtils
	include FileTest
	
	#
	# Crea un nuevo repositorio solo en caso de que no haya ninguno
	# existente
	#
	def wplugin_init()
		# Existe el repositorio?
		if ! (directory?(@data_dir) and
			file?("#{@data_dir}/format") and
			file?("#{@data_dir}/README.txt") and
			file?("#{@data_dir}/db/fs-type"))
			
			#Crea el repositorio
			raise StandardError, "create: invalid" if ! self.create
		end
	end
	
	#
	# Procesa una ruta de archivo con los siguientes pasos:
	#
	# 1. Verifica que la ruta sea absoluta
	# 2. Limpia la ruta
	# 3.1. Si se pasa el argumento wc_dir añade este a la ruta
	# 3.2. Si no, se añade el valor de data_dir
	#
	def process_path(path, wc_dir=false)
		if ( ! File.absolute?(path) )
			w_warn("#{path}: invalid path")
			return false, false
		else
			path = File.cleanpath(path)
			return path, "#{(wc_dir ? wc_dir : @data_dir)}/#{path}"
		end
	end
	
	private :process_path
	
	
	#
	# Crea un repositorio
	#
	def create()
		w_info("#{@data_dir}")
		
		# Se asegura que el directorio donde se creara el repositorio exista
		mkdir_p(@data_dir)
		
		cmd = Command.exec("svnadmin", "create", @data_dir)
		
		# Si el comando no ha terminado de forma exitosa
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		return true
	end
	
	#
	# Verifica si un archivo hace parte del manejador de
	# versiones o si hace parte del sistema de archivos
	#
	def repo_file?(f)
		f = File.cleanpath("%wc_dir%/#{f}")
		
		#
		# Expresiones regulares que informan que archivos hacen parte del
		# repositorio
		#
		# El string especial %wc_dir% se entiende como
		# la ruta de la copia de trabajo
		#
		files = [ /^%wc_dir%(\/|\/.*\/).svn((\/+.*)*)/ ]
		files.each do |exp|
			# El archivo es del repositorio
			return true if exp === f
		end
		
		# El archivo no es del repositorio
		return false
	end
	
	
	#
	# Realiza un checkout desde el repositorio hacia la copia de trabajo
	#
	# wc_dir: el directorio donde se encuentra la copia de trabajo
	# version: la version del repositorio que se quiere hacer checkout
	#
	def checkout(wc_dir, version=nil)
		#
		# Si no se pasa ninguna version por defecto se selecciona la ultima version
		# del repositorio
		#
		version = versions[1].last if ! version
		w_info("#{@data_dir}@#{version.get} -> #{wc_dir}")
		
		# Se ejecuta el comando checkout
		cmd = Command.exec("svn", "checkout", "file://#{@data_dir}@#{version.get}", wc_dir)
		
		# Si el comando no termino con exito
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		# El checkout se logro exitosamente
		return true
	end	
	
	#
	# Permite ver el estado de los cambios hechos en una copia de trabajo
	#
	# wc_dir: el directorio de la copia de trabajo
	#
	def status(wc_dir)
		w_info("#{wc_dir}")
		# TODO: implementar
	end
	
	#
	# Permite registrar los cambio marcados en una copia de trabajo hacia el
	# repositorio
	#
	# wc_dir: el directorio de la copia de trabajo
	# log: el nombre de los cambios (version)
	#
	def commit(wc_dir, log)
		w_info("#{wc_dir}(#{log}) -> #{@data_dir}:")
		
		# Se ejecuta el comando commit
		cmd = Command.exec("svn", "commit", "--non-interactive", "-m", log, wc_dir)
		
		# Si el comando no termino con exito
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		# El checkout se logro exitosamente
		return true
	end
	
	#
	# Retorna una lista de Repo::Version con cada version del repositorio
	#
	def versions()
		w_info("#{@data_dir}")
		
		# Se ejecuta el comando log
		cmd = Command.exec("svn", "log", "--xml", "file://#{@data_dir}")
		
		# Si el comando no termino con exito
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		#
		# Se arma la lista de versiones a partir de los datos en XML
		# arrojados por el log
		#
		ret = Array.new
		
		# El comando el contenido en formato XML bien definido
		doc = REXML::Document.new(cmd.stdout)
		
		# Cada elemento representa una version
		doc.root.each_element do |version|
			ret.push( Repo::Version.new(
				version.attribute("revision").to_s,
				version.get_text("msg"),
				version.get_text("date"),
				version.get_text("author") ))
		end
		
		# Se adiciona una version que representa la primera version del repositorio
		ret.push(Repo::Version.new(0))
		
		# Se acomodan las versiones de menor a mayor
		ret = ret.reverse
		
		# Se armo correctamente la lista de versiones
		return true, ret
	end
	
	#
	# Muestra el contenido de un archivo en el repositorio
	#
	# path: la ruta del archivo
	# version: la version del archivo
	#
	def cat(path, version=nil)
		#
		# Si no se pasa ninguna version por defecto se selecciona la ultima version
		# del repositorio
		#
		version = versions[1].last if ! version
		w_info("#{path}@#{version.get}")
		
		# Se procesa la ruta de entrada
		path, rpath = process_path(path)
		return false, "invalid path: #{path}" if ! path
		
		# Se ejecuta el comando cat
		cmd = Command.exec("svn", "cat", "file://#{rpath}@#{version.get}")
		
		# Si el comando no termino con exito
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		# El cat se logro exitosamente
		return true, cmd.stdout
	end
	
	#
	# Crea un FileTree que representa el arbol de archivos para una version
	# del repositorio
	#
	# path: la ruta desde la cual partir
	# version: la ruta del repositorio
	#
	def ls(path, version=nil)
		#
		# Si no se pasa ninguna version por defecto se selecciona la ultima version
		# del repositorio
		#
		version = versions[1].last if ! version
		w_info("#{path}@#{version.get}")
		
		# Se procesa la ruta de entrada
		path, rpath = process_path(path)
		return false, "invalid path: #{path}" if ! path
		
		# Se ejecuta el comando ls
		cmd = Command.exec("svn", "ls", "-R", "--xml", "file://#{rpath}@#{version.get}")
		
		# Si el comando no termino con exito
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		tree = FileTree.new
		
		# El comando retorna el arbol de archivos en formato XML bien definido
		doc = REXML::Document.new(cmd.stdout)
		
		doc.root.each_element do |list|
			# Cada elemento representa un archivo en el arbol de archivos
			list.each_element do |entry|
				
				# El tipo de archivo
				ftype = entry.attribute("kind").to_s
				
				# El nombre del archivo
				id = entry.get_text("name").to_s
				
				# El archivo es un directorio?
				as_dir = false
				as_dir = true if ftype == "dir"
				
				#
				# Adiciona de forma recursiva el archivo, en caso de que la
				# los directorios padres del archivo no existan esto los crea
				#
				tree.add_with_parents("/#{id}", as_dir)
			end
		end
		
		# Se armo correctamente el arbol de archivos
		return true, tree
	end
	
	#
	# Marca un archivo de un repositorio para adicion o eliminacion
	#
	# wc_dir: la ruta de la copia de trabajo
	# path: la ruta del archivo
	# cmd: el comando (add|delete)
	#
	def cmd_add_delete(wc_dir, path, *cmd)
		# Se procesa la ruta de entrada
		path, rpath = process_path(path, wc_dir)
		return false, "invalid path: #{path}" if ! path or File.root?(path)
		
		# Se ejecuta el comando <add|delete>
		cmd = Command.exec(* (["svn"] + cmd + [rpath]) )
		
		# Si el comando no termino con exito
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		# El <add|delete> se logro exitosamente
		return true
	end
	private :cmd_add_delete
	
	#
	# Mueve o copia un archivo en el repositorio
	#
	# wc_dir: la ruta de la copia de trabajo
	# path_from: la ruta a mover
	# path_to: la ruta hacia donde mover
	# cmd: el comando (move|copy)
	#
	def cmd_move_copy(wc_dir, path_from, path_to, cmd)
		# Se procesa la ruta de entrada from
		path_from, rpath_from = process_path(path_from, wc_dir)
		return false, "invalid path_from: #{path_from}" if ! path_from or File.root?(path_from)
		
		# Se procesa la ruta de to
		path_to, rpath_to = process_path(path_to, wc_dir)
		return false, "invalid path_to: #{path_to}" if ! path_to
		
		# Se ejecuta el comando <move|copy>
		cmd = Command.exec("svn", cmd, rpath_from, rpath_to)
		
		# Si el comando no termino con exito
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		# El <move|copy> se logro exitosamente
		return true
	end
	private :cmd_move_copy
	
	#
	# Adiciona un archivo al repositorio
	# para mas informacion ver cmd_add_delete()
	#
	def add(wc_dir, path)
		w_info("#{wc_dir}:#{path}")
		return cmd_add_delete(wc_dir, path, "add", "-N")
	end
	
	#
	# Elimina un archivo del repositorio
	# para mas informacion ver cmd_add_delete()
	#
	def delete(wc_dir, path)
		w_info("#{wc_dir}:#{path}")
		return cmd_add_delete(wc_dir, path, "delete")
	end
	
	#
	# Mueve un archivo en el repositorio
	# para mas informacion ver cmd_move_copy()
	#
	def move(wc_dir, path_from, path_to)
		w_info("#{wc_dir}: #{path_from} -> #{path_to}")
		return cmd_move_copy(wc_dir, path_from, path_to, "move")
	end
	
	#
	# Copia un archivo en el repositorio
	# para mas informacion ver cmd_move_copy()
	#
	def copy(wc_dir, path_from, path_to)
		w_info("#{wc_dir}: #{path_from} -> #{path_to}")
		return cmd_move_copy(wc_dir, path_from, path_to, "copy")
	end
	
end
end
