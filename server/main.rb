#
# El directorio donde reside Widely
#
$WIDELY_SERVER_HOME = File.dirname($0)
$WIDELY_HOME = "#{$WIDELY_SERVER_HOME}/.."

#
# Estos directorios deben estar en el entorno de
# busqueda de archivos
#
$: << $WIDELY_SERVER_HOME
$: << "#{$WIDELY_SERVER_HOME}/lib"

#
# Carga el Core
#
require "core/autoloads.rb"
require "core/lang/file.rb"
require "core/lang/kernel.rb"
require "core/wdebug.rb"
require "core/wmodule.rb"


#
# Carga el sistema HTTP
#
require "http/init.rb"
WModule.collection[:HTTP].load


#
# Localiza y carga todos los modulos
#
(Dir.glob("#{$WIDELY_SERVER_HOME}/{webservices,addons}/*")).each { |m| require "#{m.to_s}/init.rb" }
WModule.collection.each_value { |m| m.load if ! m.loaded }

#
# Inicia el servidor Web
#
Dispatcher.new(7777).start_server
