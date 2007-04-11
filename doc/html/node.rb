class Node
	attr_accessor :link, :name, :sub_nodes, :super_node
	
	def initialize(link, name, sub_nodes = nil)
		@link = link;
		@name = name;
		@sub_nodes = sub_nodes;
		if (@sub_nodes.is_a?(Array))
			@sub_nodes.each do |sub_node|
				sub_node.super_node = self
			end
		end
	end
	
	def path
		ret = Array.new()
		ret[ret.size] = self
		tmp_super_node = @super_node
		
		while !tmp_super_node.nil?
			ret[ret.size] = tmp_super_node
			tmp_super_node = tmp_super_node.super_node
		end
		
		return ret.reverse
	end
	
	def top_node
		p = self
		while !p.super_node.nil?
			p = p.super_node
		end
		return p
	end
	
	def find_by_link(link)
		return self if @link == link
		return nil if @sub_nodes.nil?
		
		@sub_nodes.each do |sub_node|
			ret = sub_node.find_by_link(link)
			return ret if !ret.nil?
		end
		return nil
	end
end

