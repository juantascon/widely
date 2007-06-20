#
# Restaura los valores almacenados
#

WUser::Set.instance.load_all
$CONF.save_all if ! $CONF.load_all
$CONF_LISTENERS.save_all if ! $CONF_LISTENERS.load_all
