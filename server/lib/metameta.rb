# Codigo visto en http://www.erikveen.dds.nl/monitorfunctions/index.html

require "thread"
class Module

        # Meta-Meta-Programming

        # With this, we can create monitoring functions.

        # It might not be clearly readable,
        # but it's written only once.
        # Write once, read never.
        # Forget about the internals.
        # Just use it.
        # It should be part of Ruby itself, anyway... :)

        # This wrap_method is low-level stuff.
        # If you just want to add code to a method, scroll
        # down to pre_condition and post_condition.
        # They're much easier to use.

  def wrap_method(*method_names, &block1)
    raise ArgumentError, "method_name is missing"       if method_names.empty?
    raise ArgumentError, "block is missing"             unless block1

    Thread.exclusive do
      method_names.flatten.each do |method_name|
        count =
        Module.module_eval do
          @_wm_count_ ||= 0
          @_wm_count_ +=1
        end

        module_eval <<-EOF

            # Get the method which is to be wrapped.

          method = instance_method(:"#{method_name}")   rescue nil

            # But it shouldn't be defined in a super class...

          if method.to_s != "#<UnboundMethod: " + self.to_s + "##{method_name}>"
            method      = nil
          end

          if method.nil? and ($VERBOSE or $DEBUG)
            $stderr.puts \
              "Wrapping a non-existing method ["+self.to_s+"##{method_name}]."
          end

            # Store the method-to-be-wrapped and the wrapping block.

          define_method(:"_wm_previous_#{method_name}_#{count}_") do
            [method, block1]
          end

            # Avoid this stupid "warning: method redefined".

          unless :#{method_name} == :initialize
            undef_method(:"#{method_name}")     rescue nil
          end

            # Define __class__ and __kind_of__.

          define_method(:__class__) \
                    {Object.instance_method(:class).bind(self).call}

          define_method(:__kind_of__) \
                    {|s| Object.instance_method(:"kind_of?").bind(self).call(s)}

            # Define the new method.

          def #{method_name}(*args2, &block2)
            context     = self.__class__
            context     = metaclass             if self.__kind_of__(Module)

              # Retrieve the previously stored method-to-be-wrapped (old),
              # as well as the wrapping block (new).

            previous    = context.instance_method(
                              :"_wm_previous_#{method_name}_#{count}_")
            old, new    = previous.bind(self).call

              # If there's no method-to-be-wrapped in the current class, we 
              # should look for it in the superclass.

            old ||=
              context.superclass.instance_method(:"#{method_name}") rescue nil

              # Since old is an unbound method, we should bind it.

            old &&= old.bind(self)

              # Finally...

            new.call(old, args2, block2, self)
          end
        EOF
      end
    end
  end

        # Since adding code at the beginning or at the
        # end of an instance method is very common, we
        # simplify this by providing the next methods.
        # Althoug they're named *_condition, they're
        # not checking anything. They should be named
        # *_action. But pre_action is harder to remember
        # than pre_condition. So I stick to the latter.
        #
        # Ejemplo de uso:
        #   pre_condition(:require) do |obj, method_name, args, block|
        #     args.each { |arg| p "loading source: #{arg}" }
        #   end

  def pre_condition(*method_names, &block1)
    pre_and_post_condition(true, false, *method_names, &block1)
  end

  def post_condition(*method_names, &block1)
    pre_and_post_condition(false, true, *method_names, &block1)
  end

  def pre_and_post_condition(pre, post, *method_names, &block1)
    method_names.flatten.each do |method_name|
      wrap_method(method_name) do |org_method, args2, block2, obj2|
        org_method.call(*args2, &block2)        if org_method and post

        block1.call(obj2, method_name, args2, block2)

        org_method.call(*args2, &block2)        if org_method and pre
      end
    end
  end

end

class Object

  def metaclass
    class << self
      self
    end
  end

end
