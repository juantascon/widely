#
# Manejo de un repositorio con subversion(svn)
#

module Svn
module Repository
	
	include FileUtils
	include FileTest
	
	def wplugin_init()
		if ! (directory?(@data_dir) and
			file?("#{@data_dir}/format") and
			file?("#{@data_dir}/README.txt") and
			file?("#{@data_dir}/db/fs-type"))
			
			raise StandardError, "create: invalid" if ! self.create
		end
	end
	
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
	
	def create()
		w_info("#{@data_dir}")
		mkdir_p(@data_dir)
		
		cmd = Command.exec("svnadmin", "create", @data_dir)
		
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
		# Cada repositorio define files() como un metodo que
		# retorna un array de expresiones regulares o simplemente
		# strings.
		# El string especial %wc_dir% se entiende como
		# la ruta de la copia de trabajo
		#
		files = [ /^%wc_dir%(\/|\/.*\/).svn((\/+.*)*)/ ]
		files.each do |exp|
			return true if exp === f
		end
		return false
	end
	
	
	
	def checkout(wc_dir, version=nil)
		version = versions[1].last if ! version
		w_info("#{@data_dir}@#{version.get} -> #{wc_dir}")
		
		cmd = Command.exec("svn", "checkout", "file://#{@data_dir}@#{version.get}", wc_dir)
		
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		return true
	end
	
	def status(wc_dir)
		w_info("#{wc_dir}")
		# TODO: implementar
	end
	
	def commit(wc_dir, log)
		w_info("#{wc_dir}(#{log}) -> #{@data_dir}:")
		
		cmd = Command.exec("svn", "commit", "--non-interactive", "-m", log, wc_dir)
		
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		return true
	end
	
	def versions()
		w_info("#{@data_dir}")
		cmd = Command.exec("svn", "log", "--xml", "file://#{@data_dir}")
		
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		ret = Array.new
		doc = REXML::Document.new(cmd.stdout)
		doc.root.each_element do |version|
			ret.push( Repo::Version.new(
				version.attribute("revision").to_s,
				version.get_text("msg"),
				version.get_text("date"),
				version.get_text("author") ))
		end
		ret.push(Repo::Version.new(0))
		ret = ret.reverse
		
		return true, ret
	end
	
	
	
	def cat(path, version=nil)
		version = versions[1].last if ! version
		w_info("#{path}@#{version.get}")
		
		path, rpath = process_path(path)
		return false, "invalid path: #{path}" if ! path
		
		cmd = Command.exec("svn", "cat", "file://#{rpath}@#{version.get}")
		
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		return true, cmd.stdout
	end
	
	def ls(path, version=nil)
		version = versions[1].last if ! version
		w_info("#{path}@#{version.get}")
		
		path, rpath = process_path(path)
		return false, "invalid path: #{path}" if ! path
		
		cmd = Command.exec("svn", "ls", "-R", "--xml", "file://#{rpath}@#{version.get}")
		
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		tree = FileTree.new
		doc = REXML::Document.new(cmd.stdout)
		doc.root.each_element do |list|
			list.each_element do |entry|
				ftype = entry.attribute("kind").to_s
				id = entry.get_text("name").to_s
				
				as_dir = false
				as_dir = true if ftype == "dir"
				
				tree.add_with_parents("/#{id}", as_dir)
			end
		end
		
		return true, tree
	end
	
	
	
	def cmd_add_delete(wc_dir, path, *cmd)
		path, rpath = process_path(path, wc_dir)
		return false, "invalid path: #{path}" if ! path or File.root?(path)
		
		cmd = Command.exec(* (["svn"] + cmd + [rpath]) )
		
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		return true
	end
	private :cmd_add_delete
	
	def cmd_move_copy(wc_dir, path_from, path_to, cmd)
		path_from, rpath_from = process_path(path_from, wc_dir)
		return false, "invalid path_from: #{path_from}" if ! path_from or File.root?(path_from)
		
		path_to, rpath_to = process_path(path_to, wc_dir)
		return false, "invalid path_to: #{path_to}" if ! path_to
		
		cmd = Command.exec("svn", cmd, rpath_from, rpath_to)
		
		if ! cmd.status.success?
			w_warn("Fail -- #{cmd.stderr}")
			return false, cmd.stderr
		end
		
		return true
	end
	private :cmd_move_copy
	
	
	def add(wc_dir, path)
		w_info("#{wc_dir}:#{path}")
		return cmd_add_delete(wc_dir, path, "add", "-N")
	end
	
	def delete(wc_dir, path)
		w_info("#{wc_dir}:#{path}")
		return cmd_add_delete(wc_dir, path, "delete")
	end
	
	def move(wc_dir, path_from, path_to)
		w_info("#{wc_dir}: #{path_from} -> #{path_to}")
		return cmd_move_copy(wc_dir, path_from, path_to, "move")
	end
	
	def copy(wc_dir, path_from, path_to)
		w_info("#{wc_dir}: #{path_from} -> #{path_to}")
		return cmd_move_copy(wc_dir, path_from, path_to, "copy")
	end
	
end
end
