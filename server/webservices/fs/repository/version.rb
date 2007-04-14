module FS
class Repository

#
# Identifica una version dentro de un repositorio
#
class Version
	attr_reader :id, :description, :date, :author
	
	def initialize(id, description = "", date = nil, author = "")
		@id = id
		@description = description
		@date = date
		@author = author
	end
	
	def get
		id.to_s
	end
end

end
end
