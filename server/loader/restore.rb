#
# Restaura los valores almacenados
#

WUser::Set.instance.load_all
WUser::Set.instance.load_all_extra_attrs()
WUser::Set.instance.add(WUser.new("test", "test")) if ! WUser::Set.instance.get("test")

$CONF.save_all if ! $CONF.load_all
$CONF_LISTENERS.save_all if ! $CONF_LISTENERS.load_all
