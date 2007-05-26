module Download

class Download
	
	include DynamicDelegator
	
	attr_reader :file_tree
	
	def initialize(wc, version, manager_id=:default)
		w_debug("wc: #{wc} version: #{version} manager_id: #{manager_id}")
		
		@file_tree = wc.ls("/", version)
		
		@file_tree.root.each { |f| f.content = @wc.cat(f.fullpath, @version) if f.type == FileTree::FTYPE::FILE }
		
		start_forward(manager_id)
	end
	
end
end
