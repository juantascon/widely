#
# El directorio donde reside Widely
#
require "pathname"
$WIDELY_HOME = Pathname.new("#{File.dirname($0)}/..").realpath.to_s
$WIDELY_HOME_SERVER = "#{$WIDELY_HOME}/server"
$WIDELY_HOME_GUI = "#{$WIDELY_HOME}/gui"
$WIDELY_HOME_DOC = "#{$WIDELY_HOME}/doc"


#
# Estos directorios deben estar en el entorno de
# busqueda de archivos
#
$: << $WIDELY_HOME_SERVER
$: << "#{$WIDELY_HOME_SERVER}/lib"

#
# Carga las rubygems utilizadas por varios modulos
#
require "rubygems"

#
# Carga el Core
#
require "core/autoloads.rb"

require "core/lang/file.rb"
require "core/lang/kernel.rb"
require "core/lang/class.rb"
require "core/lang/collection.rb"
require "core/lang/plugin.rb"

require "core/wdebug.rb"
require "core/wconfig.rb"
require "core/wmodule.rb"

#
# El directorio de datos por defecto
#
$CONFIG.add(WConfig::StringProperty.new("CORE_DATA_DIR", "/tmp"))

#
# Localiza y carga todos los modulos
#
(Dir.glob("#{$WIDELY_HOME_SERVER}/{listeners,webservices,addons}/*")).each { |m| require "#{m.to_s}/init.rb" }
WModule.each_wmodule { |name, m| m.load if ! m.loaded }

#
# Inicia los servidores cada uno en un hilo
#
servers_group = Array.new
threads_group = Array.new
[ HTTPAPI::Dispatcher.new(7777), HTTPStatic::Dispatcher.new(7778), WebDav::Dispatcher.new(7779) ].each do |s|
	servers_group.push(s)
	threads_group.push(s.run)
end

#
# Atrapa las señales para que sean manejadas correctamente
#
["INT", "TERM" ].each { |signal| trap(signal) { servers_group.each { |server| server.stop } } }
w_info ""
w_info " ================================ "
w_info " => Ctrl-C to stop the servers <= "
w_info " ================================= "
w_info ""


#
# Hace que el hilo principal espere a que
# los otros hilos terminen
#
threads_group.each { |t| t.join }
