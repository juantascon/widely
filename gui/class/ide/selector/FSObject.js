qx.Mixin.define("ide.selector.FSObject",
{
	
	include: lib.dao.WC,
	
	properties:
	{
		name: { check: "String", init: "" },
		path: { check: "String", init: ""},
		version: { check: "Number" }
	},
	
	members:
	{
		is_read_only: function() {
			return ( this.getVersion() != cons.WC);
		},
		
		full_name: function() {
			return ( "" + this.getPath() + "/" + this.getName() );
		},
		
		initialize_fs_object: function(name, path, version) {
			this.setName(name);
			this.setPath(path);
			this.setVersion(version);
		}
	}
});
