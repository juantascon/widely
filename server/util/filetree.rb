module Util
class FileTree
	
	
	module FTYPE
		FILE = 0
		DIR = 1
	end
	
	
	class FileNode
		attr_reader :parent, :id, :ftype
		
		def initialize(parent, id)
			@parent = parent
			@id = id
			@ftype = FTYPE::FILE
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
			@ftype = FTYPE::DIR
			@childs = Array.new
		end
		
		def add(id, as_dir=false)
			new_node = (as_dir ? FileNode.new(self, id) : DirNode.new(self, id))
			@childs.push(new_node)
			return new_node
		end
		
		def child(id)
			@childs.each {|c| return c if c.id == id }
			return nil
		end
	end
		
	attr_reader :root
	
	def initialize()
		@root = DirNode.new(nil, "")
	end
	
	def add_path(path, as_dir)
		realpath = Pathname.new(path).cleanpath
		(w_warn("#{path} -> not an absolute path") ; return false) if ! realpath.absolute?
		
		parent = @root
		realpath.dirname.each_filename do |p|
		(w_warn("#{p} -> not a dir") ; return false) if parent.child(p).ftype != FTYPE::DIR
		if parent.child
		parent.add(p, true) 
			
		
	end
	
	
end
end
