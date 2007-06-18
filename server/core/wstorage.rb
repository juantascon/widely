module WStorage

class InvalidFileException < Exception
	def initialize(filename, msg=nil)
		super("Invalid Config File: #{filename} #{msg}")
	end
end

module Storable
	
	def Storable.included(mod)
		class << mod
			
			def new_from_storage(data, config_file)
				data_dir = File.cleanpath("#{File.dirname(config_file)}/data_dir")
				
				obj = allocate
				
				Thread.critical = true
				
				class << obj
					def set_storage_paths(config_file, data_dir)
						@config_file = config_file
						@data_dir = data_dir
					end
				end
				
				obj.set_storage_paths(config_file, data_dir)
				
				class << obj
					undef_method :set_storage_paths
				end
				
				Thread.critical = false
				
				obj.initialize_from_storage(data)
				return obj
			end
			
		end
	end
	
	def initialize_from_storage(data)
	end
	
	def validate_id(id)
		return false if ! id.kind_of? String
		
		regexp = /[a-zA-Z][a-zA-Z0-9_-]*/
		return false if ! regexp === id
		return false if ! regexp.match(id)[0] == id
		
		return true
	end
	
	def to_h()
		{ "object_id" => self.object_id  }
	end
	
end


module Storager
	
	def load_from_file(filename)
		begin
			file = File.new(filename)
			data = YAML::load(file)
			file.close
			
			return data
		rescue Exception => ex
			w_info("Imposible to load from file: #{filename}")
			return false
		end
	end
	
	def save_to_file(filename, data)
		begin
			FileUtils.mkdir_p(File.dirname(filename))
			file = File.new(filename, "w+")
			
			YAML::dump(data, file)
			file.close
			
			return true
		rescue Exception => ex
			w_debug(ex)
			w_info("Imposible to save to file: #{filename}")
			return false
		end
	end
	
end


class DistributedStorager < WCollection
	
	include Storager
	
	attr_reader :path_format
	
	def initialize(klass=Object, path_format="", parent=nil)
		@path_format = path_format
		raise wex_arg("path_format", @path_format) if (@path_format.scan("%s").size != 1)
		
		super(klass, parent)
		load_all
	end
	
	def add_at(key, object)
		raise wex_arg("key", key, "(nice try)") if (key.include? "/" || key[0..0] == ".")
		
		ret = super(key, object)
		save(key)
		return ret
	end
	
	def load(key)
		begin
			filename = @path_format % key
			data = load_from_file(filename)
			
			object = @klass.new_from_storage(data, filename)
			self.add(object)
			
			return true
		rescue Exception => ex
			w_info("Invalid Config File: #{filename}")
			return false
		end
	end
	
	def save(key)
		object = get(key)
		return false if ! object
		
		filename = @path_format % key
		data = object.to_h
		
		return save_to_file(filename, data)
	end
	
	def load_all()
		Dir.glob(@path_format % "*").each do |filename|
			key = Regexp.new(@path_format % "(.*)").match(filename)[1]
			load(key)
		end
	end
	
	def save_all()
		self.each do |key, object|
			save(key, object)
		end
	end
	
end


class CentralizedStorager < WCollection
	
	include Storager
	
	attr_reader :config_file
	
	def initialize(klass=Object, config_file="", parent=nil)
		@config_file = config_file
		super(klass, parent)
	end
	
	def load_all()
		begin
			data = load_from_file(@config_file)
			
			data.each do |key, value|
				object = @klass.new_from_storage(value, @config_file)
				self.add(object)
			end
			
			return true
		rescue Exception => ex
			w_info("Invalid Config File: #{@config_file}")
			return false
		end
	end
	
	def save_all()
		data = Hash.new
		self.each { |key, object| data[key] = object.to_h }
		
		save_to_file(filename, data)
	end
	
end

end
