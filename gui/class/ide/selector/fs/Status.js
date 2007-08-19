/*
 * TODO: doc
 *
 */
qx.Class.define("ide.selector.fs.Status",
{
	type: "static",
	
	statics:
	{
		NORMAL: 0,
		
		MODIFIED: 1,
		
		ADDED: 2,
		
		NOCONTROL: 3,
		
		DELETED: 4,
		
		CONFLICTED: 5
	}
});
