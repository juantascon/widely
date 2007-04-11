#! /usr/bin/ruby

def submenu()
print '
<div id="leftside">
<a id="sectionmenu"></a>
<p class="soft">
	<br/>Bienvenido a la pagina de desarollo de Widely.
</p>
<h1>Contenido:</h1>
<p class="menublock">
'
	REFS.each do |sub_node|
		print "\t"+'<a class="nav" href="'+sub_node.link+'">'+sub_node.name+'</a><br class="hide"/>'+"\n"
	end
print '
</p>
</div>
'
end
