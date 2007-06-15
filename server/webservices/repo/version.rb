module Repo

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
	
	def to_h
		return {
			"id" => @id,
			"description" => @description,
			"date" => @date,
			"author" => @author
		}
	end
	
	def to_json
		to_h.to_json
	end
end

end
