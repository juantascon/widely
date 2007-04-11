#! /usr/bin/ruby

def submenu()
print '
<div id="leftside">
<a id="sectionmenu"></a>
<p class="soft">
	<br/>En esta seccion se encuentra toda la documentacion de desarrollo de Widely.
</p>
<h1>Documentacion:</h1>
<p class="menublock">
'
	@current_node.top_node.sub_nodes.each do |sub_node|
		print "\t"+'<a class="nav" href="'+sub_node.link+'">'+sub_node.name+'</a><br class="hide"/>'+"\n"
		sub_node.sub_nodes.each do |subsub_node|
			print "\t"+'<a class="nav sub" href="'+subsub_node.link+'">'+subsub_node.name+'</a><br class="hide"/>'+"\n"
		end if !sub_node.sub_nodes.nil?
	end
print '
</p>
</div>
'
end
