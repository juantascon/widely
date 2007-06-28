qx.Class.define("lib.lang.Encode",
{
	statics:
	{
		encodeObj: function(obj){
			if ( qx.util.Validation.isInvalidObject(obj) ) { return obj; }
			
			var ret = "";
			for (var key in obj) {
				ret += ( encodeURI(key) + "=" + encodeURI(obj[key]) + "&" );
			}
			return ret.substr(0, ret.length-1);
		}
	}
});
