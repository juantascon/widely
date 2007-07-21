#
# Restaura los valores almacenados
#

w_debug("restoring objects ...")
WUser::Set.instance.load_all
WUser::Set.instance.load_all_extra_attrs()
w_debug("objects restored")

$CONF.save_all if ! $CONF.load_all
$CONF_LISTENERS.save_all if ! $CONF_LISTENERS.load_all
