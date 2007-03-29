#todo:
#terminar: cat, ls, status y file_save

module FS
class WorkingCopy
	include FileUtils
	include FileTest
	
	attr_reader :repository, :user, :wc_dir
	
	def initialize(user, wc_dir, repository)
		@wc_dir = wc_dir
		@repository = repository
	end
	
	def wc_path(path)
		realpath = Pathname.new(path).cleanpath
		if realpath.absolute?
			return "#{@wc_dir}/#{realpath.to_s}"
		else
			w_warn("#{path} -> invalid path")
			return false
		end
	end
	private :wc_path
	
	
	def checkout(version=versions.last)
		mkdir @wc_dir if ! directory? @wc_dir
		repository.checkout(@wc_dir, version)
	end
	
	def cat(path, version=nil)
		
	end
	
	def ls(path, version=nil)
	end
	
	
	def status()
		repository.status(@wc_dir)
	end
	
	def commit(log)
		repository.commit(@wc_dir, log.to_s)
	end
	
	
	def add(path, as_dir=false)
		realpath = wc_path(path)
		return false if ! realpath
		
		if ! exist?(realpath)
			mkdir(realpath) if as_dir
			touch(realpath)
		end
		
		@repository.add(@wc_dir, realpath)
	end
	
	def delete(path)
		realpath = wc_path(path)
		return false if ! realpath
		
		@repository.delete(@wc_dir, realpath) if exist?(realpath)
		rm_rf(realpath) if exist?(realpath)	
	end
	
	def move(path_from, path_to)
		realpath_from = wc_path(path_from)
		realpath_to = wc_path(path_to)
		return false if ! ( realpath_from or realpath_to )
		
		if exist?(realpath_from)
			if directory?(realpath_to) or
				directory?(File.dirname(realpath_to))
				
				@repository.move(@wc_dir, realpath_from, realpath_to)
			else
				return false
			end
		end
		
		mv(realpath_from, realpath_to) if exist?(realpath_from)
	end
	
	
	def versions()
		@repository.versions()
	end
	
	def file_save(path, content)
	end
	
end
end
