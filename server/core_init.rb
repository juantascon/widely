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


at_exit do
	print "Limpiando\n"
	Dir.glob("/tmp/{repos*,wc*}").each { |d| FileUtils.rm_rf d }
end

wc = "/tmp/wc"
repos = Svn::RepositorySvn.new("/tmp/repos");
repos.create
repos.checkout(wc)
f = File.new("#{wc}/testfile1", "w+"); f.print("hola\n"); f.close
repos.add(wc, "/testfile1")
repos.commit(wc, "version1")
p repos.cat("/testfile1")
f = File.new("#{wc}/testfile1", "w+"); f.print("bien?\n"); f.close
repos.commit(wc, "version2")

repos.checkout(wc)

p repos.cat ("/testfile1", repos.versions[1])
gets
