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
require "core/lang/hash.rb"

#
# Carga el Core
#

require "core/wdebug.rb"
require "core/wcollection.rb"
require "core/wstorage.rb"
require "core/wconfig.rb"
require "core/wmodule.rb"
require "core/wplugin.rb"
require "core/wuser.rb"
