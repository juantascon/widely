# TODO:
# * adicionar soporte para permisos de usuarios
# * definir root_dir en initialize

module FS
class Project
	attr_reader :name, :repository, :wc, :root_dir
	
	def initialize(name, repository)
		@name = name
		@repositoy = repository
		@wc = WorkingCopy(
	end
	
	def create_workingcopy(user)
		WorkingCopy.new(user, @root_dir, @repository)
	end
end
end
