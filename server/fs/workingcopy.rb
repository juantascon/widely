module FS
class WorkingCopy
	attr_reader :repository, :user, :root_dir
	
	def initialize(user, root_dir, repository)
		@root_dir = "#{root_dir}"
		@repository = repository
	end
	
	def real_path(path)
		"#{@root_dir}/#{path}"
	end
	
	# Actualiza wc a partir de una version en el repositorio
	def checkout(version=nil)
		repository.checkout(@root_dir, version)
	end
	
	# Muestra las diferencias entre el repositorio y el wc
	def status()
		repository.status(@root_dir)
	end
	
	# Envia las diferencias al repositorio
	def commit()
		repository.commit(@root_dir)
	end
	
	def file_create(path, as_dir=false)
		if ! File.exist?(real_path(path))
			if as_dir
				Dir.mkdir(real_path(path))
				@repository.dir_create(@root_dir, path)
			else
				File.new(real_path(path))
				@repository.file_add(@root_dir, path)
			end
		end
	end
	
	def file_delete(path)
		if File.exist?(real_path(path))
			FileUtils.rm_rf(real_path(path))
			@repository.file_remove(@root_dir, path)
		end
	end
	
	def file_move(path_from, path_to)
		if (
			File.exist?(real_path(path_from)) and
			! File.exist?(real_path(path_to)) and
			File.directory?(real_path(path_to).dirname)
		)
			File.rename(real_path(path_from), real_path(path_to))
			@repository.file_move(@root_dir, path)
		end
	end
	
	def file_save(path, content)
	end
	
	def file_cat(path, version=Version::WC)
		case version
			when Version::WC
				if (File.exist?(real_path(path)))
					return File.read(path)
				end
			else
				@repository.file_cat(@root_dir, path, version)
		end
	end
	
	def dir_list(path, version=Version::WC)
		case version
			when Version::WC
				if (File.directory?(real_path(path)))
					return (Dir.entries(real_path(path)) - ["."] - [".."])
				end
			else
				@repository.dir_list(@root_dir, path, version)
		end
	end
	
	private :real_path
end
end
