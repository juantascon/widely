var ftv;
var layout;
var editor;

Init = function(){
	return {
		init : function(){
			Ext.BLANK_IMAGE_URL = "lib/ext/resources/images/default/s.gif";
			log_reader = new YAHOO.widget.LogReader(null,{top:"10%",right:"10px"});
			ftv = new FileTreeView();
			layout = new Layout();
			editor = new Editor();
		}
	};
}();

Ext.onReady(Init.init, Init, true);
