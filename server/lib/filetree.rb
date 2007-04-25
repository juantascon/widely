#
# Abstraccion de un arbol de archivos
# Ejemplo:
#
# Filetree
# |-> / (DirNode)
#     |-> etc (DirNode)
#         |-> rc.conf (FileNode)
#         |-> fstab (FileNode)
#         |-> passwd (FileNode)
#     |-> home (DirNode)
#         |-> perensejo (DirNode)
#             |-> archivo1 (DirNode)
#             |-> archivo2 (DirNode)
#     |-> bin (DirNode)
#

require "json"

class FileTree
	#
	# Define el tipo de archivo(directorio, regular, especial, socket unix, etc)
	#
	module FTYPE
		FILE = 0
		DIR = 1
	end
	
	#
	# Nodo tipo archivo
	# de este nodo deberian heredar todos los otros nodos
	# (un directorio es un archivo con mas archivos adentro)
	#
	class FileNode
		attr_reader :parent, :id, :ftype
		
		def initialize(parent, id)
			@parent = parent
			@id = id
			@ftype = FTYPE::FILE
		end
		
		#
		# retorna la ruta completa hasta el directorio raiz
		#
		def fullpath()
			path = Array.new
			p = self
			while p
				path.push(p.id)
				p = p.parent
			end
			return path.reverse.join("/")
		end
		
		def to_h
			return {
				"text" => id,
				"id" => fullpath,
				"childs" => false,
				"type" => "file"
			}
		end
	end
	
	#
	# Nodo tipo directorio
	#
	class DirNode < FileNode
		attr_reader :childs
		
		def initialize(parent, id)
			@parent = parent
			@id = id
			@ftype = FTYPE::DIR
			@childs = Array.new
		end
		
		#
		# Agrega un nodo como hijo, puede ser
		# un archivo u otro directorio
		#
		def add(id, as_dir=false)
			# Prueba que no exista el hijo
			if child(id)
				# Si existe verifica que tenga el tipo adecuado, sino aborta
				if child(id).ftype != (as_dir ? FTYPE::DIR : FTYPE::FILE)
					return false
				else
					return child(id)
				end
			else
				# Si no existe solo lo crea, lo agrega a sus hijos y lo retorna
				new_node = (as_dir ? DirNode : FileNode).new(self, id)
				@childs.push(new_node)
				return new_node
			end
		end
		
		#
		# Obtiene un hijo de este directorio a partir de su ID
		#
		def child(id)
			@childs.each {|c| return c if c.id == id }
			return nil
		end
		
		def to_h
			childs_h = Array.new
			@childs.each{ |c| childs_h.push(c.to_h) }
			
			return {
				"text" => id,
				"id" => fullpath,
				"childs" => childs_h,
				"type" => "dir"
			}
		end
		
		def to_a
			list = Array.new
			@childs.each { |c| list.push(c.to_h) }
			return list
		end
	end
	
	attr_reader :root
	
	def initialize(root_dir="")
		@root = DirNode.new(nil, root_dir)
	end
	
	#
	# Agrega todos los directorios padres desde la raiz y luego crea el hijo
	# Similar a FileUtils.mkdir_p
	#
	def add_with_parents(path, as_dir=false)
		realpath = Pathname.new(path).cleanpath
		(w_warn("#{path} -> not an absolute path") ; return false) if ! realpath.absolute?
		
		# Primero se crean los directorios padres de forma iterativa
		parent = @root
		realpath.dirname.each_filename do |id|
			child = parent.add(id, true)
			(w_warn ("#{path}(#{id}): not a directory"); return false) if ! child
			parent = child
		end
		
		# Luego se agrega el hijo
		ret = parent.add(realpath.basename.to_s, as_dir)
		(w_warn ("#{path}: not a directory"); return false) if ! ret
		return ret
	end
	
	def to_json
		@root.to_a.to_json
	end
end
