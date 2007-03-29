$WIDELY_HOME = File.dirname($0)

$: << $WIDELY_HOME
$: << "#{$WIDELY_HOME}/lib"

# Core
require "ruby_extensions.rb"
require "wdebug.rb"
require "wmodule.rb"

["Util", "FS"].each { |m| require "#{m.downcase}/init.rb" }

begin
	WModule.collection.each_value { |m| m.start; m.load }
rescue WE
	w_fatal("All core modules must be initialized")
end

Dir.glob("addons/*").each do |m|
	require "#{m}/init.rb" if File.directory? m
end

WModule.collection.each_value { |m| ( m.start; m.load ) if m.status == WModule::CREATED }
