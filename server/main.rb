$WIDELY_HOME = File.dirname($0)

$: << $WIDELY_HOME
$: << "#{$WIDELY_HOME}/lib"

# Core
require "core/autoloads.rb"
require "core/ruby-ext.rb"
require "core/wdebug.rb"
require "core/wmodule.rb"

( ["Util", "Auth", "FS"] + Dir.glob("addons/*") ).each { |m| require "#{m.downcase}/init.rb" }

WModule.collection.each_value { |m| m.load }

require "test.rb"
