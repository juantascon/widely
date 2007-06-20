#
# El directorio donde reside Widely
#
require "pathname"
$WIDELY_HOME = Pathname.new("#{File.dirname($0)}/..").realpath.to_s
$WIDELY_HOME_SERVER = "#{$WIDELY_HOME}/server"
$WIDELY_HOME_GUI = "#{$WIDELY_HOME}/gui"
$WIDELY_HOME_DOC = "#{$WIDELY_HOME}/doc"
$WIDELY_DATA_DIR = "#{ENV["HOME"]}/.widely"

#
# Define el espacio de listeners y threads
#
$WIDELY_LISTENERS = Hash.new
$WIDELY_THREADS = Array.new

#
# Estos directorios deben estar en el entorno de
# busqueda de archivos
#
$: << $WIDELY_HOME_SERVER
$: << "#{$WIDELY_HOME_SERVER}/lib"


require "loader/autoloads.rb"
require "loader/core.rb"
require "loader/wmodules.rb"
require "loader/restore.rb"
require "loader/listeners.rb"
