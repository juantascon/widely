module Download
class Download < Pluginable
	
	attr_reader :file_tree
	
	def initialize(wc, version, manager)
		@file_tree = wc.ls("/", version)
		@file_tree.root.each { |f| f.content = @wc.cat(f.fullpath, @version) if f.type == FileTree::FTYPE::FILE }
		
		super()
		activate_plugin(manager)
	end
	
end
end
