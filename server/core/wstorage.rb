module WStorage

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
	
	def to_h()
		{ "object_id" => self.object_id  }
	end
	
end


module Storager
	
	def load(filename)
		begin
			file = File.new(filename)
			data = YAML::load(file)
			return data
		rescue Exception => ex
			w_info("Imposible to load: #{filename}")
			w_debug(ex)
			
			return false
		end
	end
	
	def save(filename, data)
		begin
			file = File.new(filename, "w+")
			FileUtils.mkdir_p(File.dirname(file.path))
			
			YAML::dump(data, file)
			return true
		rescue Exception => ex
			w_info("Imposible to save: #{filename}")
			w_debug(ex)
			return false
		end
	end
	
end


class DistributedStorager < WCollection
	
	include Storager
	
	attr_reader :path_format
	
	def initialize(klass=Object, path_format="", parent=nil)
		super(klass, parent)
		
		@path_format = path_format
	end
	
	def add_at(key, object)
		raise ArgumentError, "#{key}: invalid key (nice try)" if (key.include? "/" || key[0..0] == ".")
		return super(key,object)
	end
	
	def load()
		Dir.glob(@path_format % [ "*" ]).each do |filename|
			data = super(filename)
			return false if ! data
			
			object = @klass.new_from_storage(data, filename)
			self.add(object)
			
			return object
		end
	end
	
	def save()
		self.each do |key, object|
			filename = @path_format % [ key ]
			data = object.to_h
			super(filename, object)
		end
	end
	
end


class CentralizedStorager < WCollection
	
	include Storager
	
	attr_reader :config_file
	
	def initialize(klass=Object, config_file="", parent=nil)
		super(klass, parent)
		
		@config_file = config_file
	end
	
	def load()
		data = super(@config_file)
		return false if ! data
		
		data.each do |key, value|
			object = @klass.new_from_storage(value, @config_file)
			self.add(object)
		end
		
		return true
	end
	
	def save()
		data = Hash.new
		self.each { |key, object| data[key] = object.to_h }
		
		super(filename, data)
	end
	
end

end
