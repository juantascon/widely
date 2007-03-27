module FS

class FSTree
	
	module FTYPE
		FILE = 1
		DIR = 2
	end
	
	class Node
		attr_reader :parent, :id, :ftype, :childs
		
		def initialize(parent, id, ftype, childs)
			@parent = parent
			@id = id
			@ftype = ftype
			@childs = childs
		end
	end
	
	class FileNode < Node
		def initialize(parent, id)
			super(parent, id, FTYPE::FILE, false)
		end
	end
	
	class DirNode < Node
		def initialize(parent, id)
			super(parent, id, FTYPE::FILE, Array.new)
		end
		
		def create_file(id)
			childs.push(FileNode.new(self, id))
		end
		def create_dir(id)
			childs.push(DirNode.new(self, id))
		end
	end
	
	attr_reader :root_node
	
	def initialize(root_node_id)
		@root_node = DirNode.new(nil, root_node_id)
	end
	
end
end
