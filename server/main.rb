$WIDELY_HOME = File.dirname($0)

$: << $WIDELY_HOME
$: << "#{$WIDELY_HOME}/lib"

# Core
require "ruby_extensions.rb"
require "wdebug.rb"
require "wmodule.rb"

( ["Util", "FS"]+ Dir.glob("addons/*") ).each { |m| require "#{m.downcase}/init.rb" }

WModule.collection.each_value { |m| m.start; m.load }

require "test.rb"
