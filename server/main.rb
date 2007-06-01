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
# Carga el resto
#
require "loader/autoloads.rb"
require "loader/core.rb"
require "loader/wmodules.rb"
require "loader/listeners.rn"
