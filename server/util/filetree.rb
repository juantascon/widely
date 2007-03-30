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
		
		def fullpath()
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
			@parent = parent
			@id = id
			@ftype = FTYPE::DIR
			@childs = Array.new
		end
		
		def add(id, as_dir=false)
			new_node = (as_dir ? DirNode.new(self, id) : FileNode.new(self, id))
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
	
	def add_with_parents(path, as_dir=false)
		realpath = Pathname.new(path).cleanpath
		(w_warn("#{path} -> not an absolute path") ; return false) if ! realpath.absolute?
		
		#Primero se crean los directorios padres de forma iterativa
		parent = @root
		realpath.dirname.each_filename do |p|
			if parent.child(p)
				if parent.child(p).ftype != FTYPE::DIR
					w_warn("#{path}:#{p} -> not a dir")
					return false
				else
					parent = parent.child(p)
				end
			else
				parent = parent.add(p, true)
			end
		end
		
		#Luego se agrega el hijo
		return parent.add(realpath.basename.to_s, as_dir)
	end
	
end
end
