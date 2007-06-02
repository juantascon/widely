# Manejo de un repositorio con subversion(svn)
# todo:
# status()

module Svn
module Repository
	
	include FileUtils
	include FileTest
	
	def files
		[ /^%wc_dir%(\/|\/.*\/).svn((\/+.*)*)/ ]
	end
	
	def init_repos()
		raise ArgumentError.new("dir[#{@data_dir}]: invalid") if ! @data_dir.kind_of? String
		raise ArgumentError.new("dir[#{@data_dir}]: not an absolute path") if ! File.absolute?(@data_dir)
		
		create_ok = self.create if ! exists
		raise StandardError.new("create: invalid") if ! create_ok
	end
	
	
	def exists()
		return (directory?(@data_dir) and file?(@data_dir+"format") and file?(@data_dir+"README.txt") and file?(@data_dir+"db"+"fs-type"))
	end
	
	def create()
		w_info("#{@data_dir}")
		mkdir_p(@data_dir)
		cmd = Command.exec("svnadmin", "create", @data_dir)
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?
		return true
	end
	
	def checkout(wc_dir, version=versions.last)
		w_info("#{@data_dir}@#{version.get} -> #{wc_dir}")
		cmd = Command.exec("svn", "checkout", "file://#{@data_dir}@#{version.get}", wc_dir)
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?
		return true
	end
	
	def status(wc_dir)
		w_info("#{wc_dir}")
		@context.status(wc_dir)
	end
	
	def commit(wc_dir, log)
		w_info("#{wc_dir}(#{log}) -> #{@data_dir}:")
		cmd = Command.exec("svn", "commit", "--non-interactive", "-m", log, wc_dir)
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?
		return true
	end
	
	
	def versions()
		w_info("#{@data_dir}")
		cmd = Command.exec("svn", "log", "--xml", "file://#{@data_dir}")
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?
		
		ret = Array.new
		doc = REXML::Document.new(cmd.stdout)
		doc.root.each_element do |version|
			ret.push( Repos::Version.new(
				version.attribute("revision").to_s,
				version.get_text("msg"),
				version.get_text("date"),
				version.get_text("author") ))
		end
		ret.push(Repos::Version.new(0))
		return ret.reverse
	end
	
	
	def cat(path, version=versions.last)
		w_info("#{path}@#{version.get}")
		path = File.cleanpath(path)
		(w_warn("#{path}: invalid path") ; return false) if ! File.absolute?(path)
		
		rpath = "#{@data_dir}/#{path}"
		cmd = Command.exec("svn", "cat", "file://#{rpath}@#{version.get}")
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?
		return cmd.stdout
	end
	
	def ls(path, version = self.versions.last)
		w_info("#{path}@#{version.get}")
		path = File.cleanpath(path)
		(w_warn("#{path}: invalid path") ; return false) if ! File.absolute?(path)
		
		rpath = "#{@data_dir}/#{path}"
		cmd = Command.exec("svn", "ls", "-R", "--xml", "file://#{rpath}@#{version.get}")
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?

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
		
		return tree
	end
	
	
	def add(wc_dir, path)
		w_info("#{wc_dir}:#{path}")
		path = File.cleanpath(path)
		(w_warn("#{path}: invalid path") ; return false) if (! File.absolute?(path)) or File.root?(path)
		
		rpath = "#{wc_dir}/#{path}"
		cmd = Command.exec("svn", "add", "-N", rpath)
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?
		return true
	end
	
	def delete(wc_dir, path)
		w_info("#{wc_dir}:#{path}")
		path = File.cleanpath(path)
		(w_warn("#{path}: invalid path") ; return false) if (! File.absolute?(path)) or File.root?(path)
		
		rpath = "#{wc_dir}/#{path}"
		cmd = Command.exec("svn", "delete", rpath)
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?
		return true
	end
	
	def move(wc_dir, path_from, path_to)
		w_info("#{wc_dir}: #{path_from} -> #{path_to}")
		path_from = File.cleanpath(path_from)
		path_to = File.cleanpath(path_to)
		(w_warn("#{path_from}: invalid path") ; return false) if (! File.absolute?(path_from)) or File.root?(path_from)
		(w_warn("#{path_to}: invalid path") ; return false) if ! File.absolute?(path_to)
		
		rpath_from = "#{wc_dir}/#{path_from}"
		rpath_to = "#{wc_dir}/#{path_to}"
		
		cmd = Command.exec("svn", "move", rpath_from, rpath_to)
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?
		return true
	end
	
end
end
