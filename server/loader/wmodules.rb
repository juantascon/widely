#
# Localiza y carga todos los modulos
#
(Dir.glob("#{$WIDELY_HOME_SERVER}/{listeners,webservices,addons}/*")).each { |m| require "#{m.to_s}/init.rb" }
WModule.each_wmodule { |name, m| m.load if ! m.loaded }
