module Zip
class Packer < Download::Base
	
	def initialize(_self)
		@_self = _self
		@file_tree = @_self.file_tree
	end
	
	def pack()
		
		@file_tree.each do |f|
			case f.ftype
				when FileTree::FTYPE::FILE then
					
				when FileTree::FTYPE::DIR then
				
				else
					
			end
		end
			
	end
	
end
end
