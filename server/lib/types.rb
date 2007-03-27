# Codigo visto en http://www.erikveen.dds.nl/monitorfunctions/index.html

class Module

        # Type checking.
        # Or duck-type checking.

        # Example:
        # class Foo
        #   def_types String, Numeric, [:to_s, :gsub]
        #   def :bar(x, y, x)
        #     # x should be Numeric
        #     # y should be a String
        #     # z should respond to :to_s and :gsub
        #   end
        # end

  def def_types(*types)
    metaclass.pre_condition(:method_added) do |obj, method_name, args, block|
      if types
        method_name     = args[0]
        t               = types
        types           = nil   # Avoid looping

        check_types(method_name, *t)
      end
    end
  end

        # Example:
        # class Foo
        #   def :bar(x, y, x)
        #     # x should be Numeric
        #     # y should be a String
        #     # z should respond to :to_s and :gsub
        #   end
        #   check_types :bar, String, Numeric, [:to_s, :gsub]
        # end

  def check_types(method_names, *types)
    [method_names].flatten.each do |method_name|
      pre_condition(method_name) do |obj, method_name, args, block|
        args.each_with_index do |arg, n|
          [types[n]].flatten.each do |typ|
            if typ.kind_of?(Module)
              unless arg.kind_of?(typ)
                raise ArgumentError, "wrong argument type " +
                                     "(#{arg.class} instead of #{typ}, " +
                                     "argument #{n+1})"
              end
            elsif typ.kind_of?(Symbol)
              unless arg.respond_to?(typ)
                raise ArgumentError, "#{arg} doesn't respond to :#{typ} " +
                                     "(argument #{n+1})"
              end
            else
              raise ArgumentError, "wrong type in types " +
                                   "(#{typ}, argument #{n+1})"
            end
          end
        end
      end
    end
  end

end
