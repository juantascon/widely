module Repos

class Default
	METHODS = [ :wplugin_init, :files, :create,
		:checkout, :status, :commit, :versions,
		:cat, :ls, :add, :delete, :move ]
	
	METHODS.each do |m|
		define_method(m) do |*args|
			w_warn("called abstract method: #{self.class.name}.#{method_name}")
		end
	end
end

Repository.register_wplugin(WPlugin.new("default", Default))

end
