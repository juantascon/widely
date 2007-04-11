#
# El directorio HOME donde reside Widely
#
$WIDELY_HOME = File.dirname($0)

#
# Estos directorios deben estar en el entorno de
# busqueda de archivos
#
$: << $WIDELY_HOME
$: << "#{$WIDELY_HOME}/lib"

#
# Carga el Core
#
require "core/autoloads.rb"
require "core/ruby-ext.rb"
require "core/wdebug.rb"
require "core/wmodule.rb"

#
# Localiza y carga todos los modulos
#
(Dir.glob("{webservices,addons}/*")+["http"]).each { |m| require "#{m.to_s}/init.rb" }
WModule.collection.each_value { |m| m.load if ! m.loaded }

#
# Inicia el servidor Web
#
#Dispatcher.new(2500)
require "test.rb"

