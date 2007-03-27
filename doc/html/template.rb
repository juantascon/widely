require "references.rb"

class HTMLTemplate

attr_accessor :current_node

def initialize(html_partial)
	REFS.each do |ref|
		@current_node = ref.find_by_link(html_partial)
		break if !@current_node.nil?
	end
end

def header
print '
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//ES" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es">
<head>
	<title>Widely</title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="description" content="Widely: Sistema de Desarrollo Web Integrado" />
	<meta name="keywords" content="web, ide" />
	<meta name="author" content="Juan Diego Tascon" />
	<link rel="stylesheet" href="css/widely.css" type="text/css" media="screen,projection" />
</head>
'
end

def body_begin
print '
<body>
<div id="container">
<a id="top"></a>
'
end

def title
print '
<div id="sitename">
<h1>Widely</h1>
<span>Sistema Web de Desarrollo Integrado</span>
<a id="menu"></a>
</div>
'
end

def general_menu()
print '
<div id="nav">
<ul>
'
	REFS.each do |ref|
		if (ref.link == @current_node.top_node.link)
			print "\t"+'<li id="current"><a href="'+ref.link+'">'+ref.name+'</a></li>'+"\n"
		else
			print "\t"+'<li><a href="'+ref.link+'">'+ref.name+'</a></li>'+"\n"
		end
	end
print '
</ul>
</div>
'
end

def top_path()
print '
<div id="topbox">
<strong><span class="hide">Currently viewing: </span>
'
	path = @current_node.path
	
	print "\t"+'<a href="'+path[0].link+'">'+path[0].name+'</a>'+"\n"
	for i in 1...path.size
		print "\t"+'&raquo; <a href="'+path[i].link+'">'+path[i].name+'</a>'+"\n"
	end
print '
</strong>
</div>
'
end

def content_fake_menu()
	print "<h1>"+@current_node.name+"</h1>\n"
	print '<p>'
	@current_node.sub_nodes.each do |sub_node|
		print "\t"+'<a href="'+sub_node.link+'">'+sub_node.name+'</a><br/>'+"\n"
	end
	print '</p>'
end

def content_from_file(filename)
	print File::read(filename)
end

def content()
print '
<a id="main"></a>
<div id="contentalt">
'
	filename = PREFIX_HTML_PARTIAL_FILE+current_node.link
	if FileTest.exists?(filename)
		content_from_file (filename)
	else
		content_fake_menu()
	end
print '
</div>
'
end

def submenu_from_file()
	[ PREFIX_SUBMENU_FILE+current_node.link, PREFIX_SUBMENU_FILE+current_node.top_node.link ].each do |f|
		if FileTest.exists?(f+".rb")
			require f
			submenu
			break
		end
	end
end

def footer
print '
<div id="footer">&copy; 2006 Widely </div>
'
end

def body_end
print '
</div>
</body>
</html>
'
end

def create_html()
	self.header()
	self.body_begin()
	self.title()
	self.general_menu()
	print "\n"+'<div id="wrap1"> <div id="wrap2">'+"\n"
	self.top_path()
	self.submenu_from_file()
	self.content()
	self.footer()
	print "\n"+'</div> </div>'+"\n"
	self.body_end()
end

end

