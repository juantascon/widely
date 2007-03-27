module Util
class StorableHash < Hash
	include Parser
	
	def initialize()
	end
	
	def load(filename)
		w_debug "loading config from file: #{filename}"
		begin
			content = IO.read(filename)
		rescue
			return false
		end
		
		key = nil
		content.gsub("\n", " ").gsub("\t", " ").split.each do |c|
			if key.nil?
				key = c
				next
			else
				self[key] = c
				key = nil
			end
		end
		return true
	end
	
	def save(filename)
		w_debug "saving config to file: #{filename}"
		begin
			output = File.new(filename, "w")
			self.each {|key, value| output.write("#{key} #{value}\n") }
			return true
		rescue => e
			w_warn("Error(#{e}) writing: #{filename}")
			return false
		end
	end
end
end
