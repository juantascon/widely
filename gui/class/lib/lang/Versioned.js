qx.Mixin.define("lib.lang.Versioned",
{
	properties:
	{
		version: { check: "Number" }
	},
	
	members:
	{
		is_read_only: function() {
			return ( this.getVersion() != cons.WC);
		}
	}
});
