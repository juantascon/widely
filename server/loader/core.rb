#
# Carga las rubygems utilizadas por varios modulos
#

require "rubygems"

#
# Carga las extensiones del lenguaje
#

require "core/lang/kernel.rb"
require "core/lang/class.rb"
require "core/lang/file.rb"

#
# Carga el Core
#

require "core/wdebug.rb"
require "core/wconfig.rb"
require "core/wmodule.rb"
require "core/wplugin.rb"

#
# El directorio de datos por defecto ( TODO: esto deberia ir en otro lado, en AUTH muy probablemente )
#
$CONFIG.add(WConfig::StringProperty.new("CORE_DATA_DIR", "/tmp/widely"))

#
# El directorio de datos por defecto ( TODO: esto deberia ir en otro lado, en Listeners muy probablemente )
#
$CONFIG.add(WConfig::StringProperty.new("CORE_LISTENERS_CONFIG_FILE", "#{$WIDELY_HOME}/listeners.yml"))
