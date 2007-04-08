$WIDELY_HOME = File.dirname($0)

$: << $WIDELY_HOME
$: << "#{$WIDELY_HOME}/lib"

# Core
require "core/autoloads.rb"
require "core/ruby-ext.rb"
require "core/wdebug.rb"
require "core/wmodule.rb"

(Dir.glob("{webservices,addons}/*")+["http"]).each { |m| require "#{m.to_s}/init.rb" }

WModule.collection.each_value { |m| m.load if ! m.loaded }

Dispatch.start(3000)

