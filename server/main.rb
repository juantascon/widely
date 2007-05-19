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
# Carga el Core
#
require "core/autoloads.rb"
require "core/lang/file.rb"
require "core/lang/kernel.rb"
require "core/wconfig.rb"
require "core/wdebug.rb"
require "core/wmodule.rb"

#
# Inicia la configuracion global
#
$CONFIG = WConfig.new_default

#
# Carga el sistema HTTP
#
require "http/init.rb"
WModule.collection[:HTTP].load

#
# Localiza y carga todos los modulos
#
(Dir.glob("#{$WIDELY_HOME_SERVER}/{webservices,addons}/*")).each { |m| require "#{m.to_s}/init.rb" }
WModule.collection.each_value { |m| m.load if ! m.loaded }

#
# Inicia el servidor Web
#
HTTP::Dispatcher.new(7777).start_server
