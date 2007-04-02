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
		
		def to_s(tab="")
			"#{tab}#{id.to_s}:file\n"
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
			if child(id)
				if child(id).ftype != (as_dir ? FTYPE::DIR : FTYPE::FILE)
					return false
				else
					return child(id)
				end
			else
				new_node = (as_dir ? DirNode : FileNode).new(self, id)
				@childs.push(new_node)
				return new_node
			end
		end
		
		def child(id)
			@childs.each {|c| return c if c.id == id }
			return nil
		end
		
		def to_s(tab="")
			str = "#{tab}#{id.to_s}:dir\n"
			@childs.each {|c| str+="#{c.to_s("#{tab}|-")}" }
			return str
		end
	end
		
	attr_reader :root
	
	def initialize(root_dir="")
		@root = DirNode.new(nil, root_dir)
	end
	
	def add_with_parents(path, as_dir=false)
		realpath = Pathname.new(path).cleanpath
		(w_warn("#{path} -> not an absolute path") ; return false) if ! realpath.absolute?
		
		#Primero se crean los directorios padres de forma iterativa
		parent = @root
		realpath.dirname.each_filename do |id|
			child = parent.add(id, true)
			(w_warn ("#{path}(#{id}): not a directory"); return false) if ! child
			parent = child
		end
		
		#Luego se agrega el hijo
		ret = parent.add(realpath.basename.to_s, as_dir)
		(w_warn ("#{path}: not a directory"); return false) if ! ret
		return ret
	end
	
end
end
