#
# Tomado de Ruby on Rails (activesupport):
# lib/active_support/core_ext/class/inheritable_attributes.rb
#

#
# Permite que los atributos sean compartibles en una jerarquia de herencia, con la
# diferencia de que cada descendiente obtiene una copia de los atributos de su padre
# en lugar de solo apuntar hacia los mismos.
# Esto significa que el hijo podria por ejemplo adicionar elementos a una array y que
# estas adiciones no se vean reflejadas en los atributos del padre
#

class Class
	def class_inheritable_reader(*syms)
		syms.each do |sym|
			next if sym.is_a?(Hash)
			class_eval <<-EOS
				def self.#{sym}
					read_inheritable_attribute(:#{sym})
				end

				def #{sym}
					self.class.#{sym}
				end
			EOS
		end
	end

	def class_inheritable_writer(*syms)
		options = syms.last.is_a?(Hash) ? syms.pop : {}
		syms.each do |sym|
			class_eval <<-EOS
				def self.#{sym}=(obj)
					write_inheritable_attribute(:#{sym}, obj)
				end

				#{"
				def #{sym}=(obj)
					self.class.#{sym} = obj
				end
				" unless options[:instance_writer] == false }
			EOS
		end
	end

	def class_inheritable_array_writer(*syms)
		options = syms.last.is_a?(Hash) ? syms.pop : {}
		syms.each do |sym|
			class_eval <<-EOS
				def self.#{sym}=(obj)
					write_inheritable_array(:#{sym}, obj)
				end

				#{"
				def #{sym}=(obj)
					self.class.#{sym} = obj
				end
				" unless options[:instance_writer] == false }
			EOS
		end
	end

	def class_inheritable_hash_writer(*syms)
		options = syms.last.is_a?(Hash) ? syms.pop : {}
		syms.each do |sym|
			class_eval <<-EOS
				def self.#{sym}=(obj)
					write_inheritable_hash(:#{sym}, obj)
				end

				#{"
				def #{sym}=(obj)
					self.class.#{sym} = obj
				end
				" unless options[:instance_writer] == false }
			EOS
		end
	end

	def class_inheritable_accessor(*syms)
		class_inheritable_reader(*syms)
		class_inheritable_writer(*syms)
	end

	def class_inheritable_array(*syms)
		class_inheritable_reader(*syms)
		class_inheritable_array_writer(*syms)
	end

	def class_inheritable_hash(*syms)
		class_inheritable_reader(*syms)
		class_inheritable_hash_writer(*syms)
	end

	def inheritable_attributes
		@inheritable_attributes ||= EMPTY_INHERITABLE_ATTRIBUTES
	end
	
	def write_inheritable_attribute(key, value)
		if inheritable_attributes.equal?(EMPTY_INHERITABLE_ATTRIBUTES)
			@inheritable_attributes = {}
		end
		inheritable_attributes[key] = value
	end
	
	def write_inheritable_array(key, elements)
		write_inheritable_attribute(key, []) if read_inheritable_attribute(key).nil?
		write_inheritable_attribute(key, read_inheritable_attribute(key) + elements)
	end

	def write_inheritable_hash(key, hash)
		write_inheritable_attribute(key, {}) if read_inheritable_attribute(key).nil?
		write_inheritable_attribute(key, read_inheritable_attribute(key).merge(hash))
	end

	def read_inheritable_attribute(key)
		inheritable_attributes[key]
	end
	
	def reset_inheritable_attributes
		@inheritable_attributes = EMPTY_INHERITABLE_ATTRIBUTES
	end

	private
		# Prevent this constant from being created multiple times
		EMPTY_INHERITABLE_ATTRIBUTES = {}.freeze unless const_defined?(:EMPTY_INHERITABLE_ATTRIBUTES)

		def inherited_with_inheritable_attributes(child)
			inherited_without_inheritable_attributes(child) if respond_to?(:inherited_without_inheritable_attributes)
			
			if inheritable_attributes.equal?(EMPTY_INHERITABLE_ATTRIBUTES)
				new_inheritable_attributes = EMPTY_INHERITABLE_ATTRIBUTES
			else
				new_inheritable_attributes = inheritable_attributes.inject({}) do |memo, (key, value)|
					memo.update(key => (value.dup rescue value))
				end
			end
			
			child.instance_variable_set('@inheritable_attributes', new_inheritable_attributes)
		end

		alias inherited_without_inheritable_attributes inherited
		alias inherited inherited_with_inheritable_attributes
end
