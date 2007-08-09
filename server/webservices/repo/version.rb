module Repo

#
# Identifica una version dentro de un repositorio
#

class Version

	attr_reader :id, :description, :date, :author
	
	#
	# id: el identificador de la version
	# description: la descipcion de la version
	# date: la fecha de creacion de la version
	# author el nombre del autor de la version
	#
	def initialize(id, description = "", date = nil, author = "")
		@id = id
		@description = description
		@date = date
		@author = author
	end
	
	#
	# Obtiene el codigo de la version
	#
	def get
		id.to_s
	end
	
	#
	# Convierte la version en Hash
	#
	def to_h
		return {
			"id" => @id,
			"description" => @description,
			"date" => @date,
			"author" => @author
		}
	end
	
	#
	# Convierte la version en formato JSON
	#
	def to_json
		to_h.to_json
	end
	
end

end
