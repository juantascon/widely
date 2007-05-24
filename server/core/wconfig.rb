class WConfig
	
	SET_PREFIX = "set_"
	GET_PREFIX = "get_"
	
	def initialize(*args, &block)
		@data = StorableHash.new(*args, &block)
	end
	
	def get_raw(name)
		@data[name]
	end
	
	def get(name)
		str = @data[name]
		return str if ! str.kind_of? String
		
		return str.gsub(/%[a-zA-Z0-9_\.]+%/) { |s| @data[s.gsub("%", "").to_sym] }
	end
	
	def set(name, value)
		@data[name] = value
	end
	
	def method_missing(name, *args)
		name = name.to_s
		
		if (name.index(SET_PREFIX) == 0) && (name.size > SET_PREFIX.size)
			set(name[SET_PREFIX.size..name.size].to_sym, args[0])
		end
		
		if (name.index(GET_PREFIX) == 0) && (name.size > GET_PREFIX.size)
			get(name[GET_PREFIX.size..name.size].to_sym)
		end
		
		raise NoMethodError.new("undefined method `#{name}' for \"#{self}\":#{self.class}", name.to_sym, args)
	end
	
	def self.new_default
		ret = new()
		
		ret.set(:CORE_DATA_DIR, "/tmp")
		ret.set(:WC_BASE_DIRNAME, "wcs")
		ret.set(:REPOS_BASE_DIRNAME, "repos")
		
		ret.set(:AUTH_KEY_SIZE, 256)
		ret.set(:AUTH_ADMIN_NAME, "admin")
		ret.set(:AUTH_ADMIN_PASSWORD, "admin")
		
		return ret
	end
	
end

