#
# Restaura los valores almacenados
#

w_debug("restoring objects ...")
User::UserSet.instance.load_all
User::UserSet.instance.load_all_extra_attrs()
w_debug("objects restored")

# Crea los archivos de configuracion en caso de que no existan
$CONF.save_all if ! $CONF.load_all
$CONF_LISTENERS.save_all if ! $CONF_LISTENERS.load_all
