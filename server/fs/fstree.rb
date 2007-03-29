module FS
class FSTree
	
	class FileNode
		attr_reader :parent, :id
		
		def initialize(parent, id)
			@parent = parent
			@id = id
		end
		
		def full_path()
			path = Array.new
			p = self
			while p
				path.push(p.id)
				p = p.parent
			end
			return path.reverse.join("/")
		end
	end
	
	class DirNode < FileNode
		attr_reader :childs
		
		def initialize(parent, id)
			super(parent, id)
			@childs = Array.new
		end
		
		def create_file(id)
			new_node = FileNode.new(self, id)
			@childs.push(new_node)
			return new_node
		end
		
		def create_dir(id)
			new_node = DirNode.new(self, id)
			@childs.push(new_node)
			return new_node
		end
	end
		
	attr_reader :root_node
	
	def initialize()
		@root_node = DirNode.new(nil, "")
	end
	
end
end
