module Collectable
	
	def self.included(base)
		base.class_eval do
			include ClassAttr
			
			class_attr :__id_count
			@__id_count = 0
			
			def self.next_id
				self.__id_count += 1
			end
		end
	end
	
	def collectable_id
		@collectable_id ||= self.class.next_id
	end
	
end
