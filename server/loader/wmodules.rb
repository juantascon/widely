#
# Localiza y carga todos los modulos
# 1. listeners
# 2. webservices
# 3. addons
#
Dir.glob("#{$WIDELY_HOME_SERVER}/listeners/*").each { |m| require "#{m.to_s}/init.rb" }
WModule.load_missing

Dir.glob("#{$WIDELY_HOME_SERVER}/webservices/*").each { |m| require "#{m.to_s}/init.rb" }
WModule.load_missing

Dir.glob("#{$WIDELY_HOME_SERVER}/addons/*").each { |m| require "#{m.to_s}/init.rb" }
WModule.load_missing

#
# Carga todos los usuarios
#
Auth::UserSet.instance.load_all
