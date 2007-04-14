function load_js(path){
	document.write('<script type="text/javascript" src="', path, '"><\/script>');
}

function load_css(path){
	document.write('<link rel="stylesheet" type="text/css" href="', path, '"><\/script>');
}

/** YUI **/
load_js("lib/yui/utilities.js");
load_js("lib/yui/logger.js");
load_css("lib/yui/assets/logger.css");
load_js("lib/ext/ext-yui-adapter.js");

/** JQuery **/
/*load_js("lib/jquery/jquery.js");
load_js("lib/ext/jquery-plugins.js");
load_js("lib/ext/ext-jquery-adapter.js");*/

/** Ext **/
load_js("lib/ext/ext-all-debug.js");
load_css("lib/ext/resources/css/ext-all.css");
//load_css("lib/ext/resources/css/ytheme-aero.css");

// Widely
var widely_js = ["filetreeview.js", "layout.js", "editor.js", "init.js"];
for (var i = 0; i < widely_js.length; i++)
{
	load_js("js/"+ widely_js[i]);
}

load_css("css/main.css");
