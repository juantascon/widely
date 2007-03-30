#todo:
#terminar: status
#fix: ls(no genera tree en version wc)

module FS
class WorkingCopy
	include FileUtils
	include FileTest
	
	attr_reader :wc_dir, :repository
	
	def initialize(wc_dir, repository)
		@wc_dir = wc_dir
		@repository = repository
	end
	
	
	def checkout(version=versions.last)
		mkdir @wc_dir if ! directory? @wc_dir
		repository.checkout(@wc_dir, version)
	end
	
	def cat(path, version=nil)
		path = File.cleanpath(path)
		(w_warn("#{path}: invalid path") ; return false) if ! File.absolute?(path)
		
		rpath = "#{@wc_dir}/#{path}"
		if version
			return @repository.cat(path, version)
		else
			return false if ! file?(rpath)
			return File.new(rpath).read
		end
	end
	
	def ls(path, version=nil)
		path = File.cleanpath(path)
		(w_warn("#{path}: invalid path") ; return false) if ! File.absolute?(path)
		
		rpath = "#{@wc_dir}/#{path}"
		if version
			return @repository.ls(path, version)
		else
			tree = FileTree.new
			Pathname.glob("#{rpath}/**", false) do |f|
				as_dir = false
				as_dir = true if f.directory?
				
				tree.add_with_parents("/#{f.to_s}", as_dir)
			end
			return tree
		end
	end
	
	
	def status()
		repository.status(@wc_dir)
	end
	
	def commit(log)
		repository.commit(@wc_dir, log.to_s)
	end
	
	
	def add(path, as_dir=false)
		path = File.cleanpath(path)
		(w_warn("#{path}: invalid path") ; return false) if (! File.absolute?(path)) or File.root?(path)
		
		rpath = "#{@wc_dir}/#{path}"
		if ! exist?(rpath)
			mkdir(rpath) if as_dir
			touch(rpath) if ! as_dir
		end
		
		@repository.add(@wc_dir, path)
	end
	
	def delete(path)
		path = File.cleanpath(path)
		(w_warn("#{path}: invalid path") ; return false) if (! File.absolute?(path)) or File.root?(path)
		
		rpath = "#{@wc_dir}/#{path}"
		@repository.delete(@wc_dir, path) if exist?(rpath)
		rm_rf(rpath) if exist?(rpath)	
	end
	
	def move(path_from, path_to)
		path_from = File.cleanpath(path_from)
		path_to = File.cleanpath(path_to)
		(w_warn("#{path_from}: invalid path") ; return false) if (! File.absolute?(path_from)) or File.root?(path_from)
		(w_warn("#{path_to}: invalid path") ; return false) if ! File.absolute?(path_to)
		
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
	
	
	def versions()
		@repository.versions()
	end
	
	def write(path, content="")
		path = File.cleanpath(path)
		(w_warn("#{path}: invalid path") ; return false) if (! File.absolute?(path)) or File.root?(path)
		
		rpath = "#{@wc_dir}/#{path}"
		return false if ! file?(rpath)
		
		file = File.new(rpath, "w")
		ret = file.write(content.to_s+"\n")
		file.fsync
		return ret
	end
	
end
end
