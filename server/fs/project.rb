# TODO:
# * adicionar soporte para permisos de usuarios
# * definir root_dir en initialize

module FS
class Project
	attr_reader :name, :repository, :wcs, :root_dir
	
	def initialize(name, repository)
		@name = name
		@wcs = Array.new
		@repository = repository
	end
	
	def create_workingcopy(user)
		WorkingCopy.new(user, @root_dir, @repository)
	end
end
end
