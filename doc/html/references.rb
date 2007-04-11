require "node.rb"

REFS =
[
	Node.new("index.html", "Inicio"),
	Node.new("documentacion.html", "Documentacion",
	[
		Node.new("formulacion.html", "Formulacion",
		[
			Node.new("casosuso.html", "Casos de Uso"),
			Node.new("arquitectura.html", "Arquitectura")
		]),
		Node.new("diseno.html", "Dise&ntilde;o",
		[
			Node.new("conceptual.html", "Modelo Conceptual"),
			Node.new("paquetes.html", "Modelo de Paquetes"),
			Node.new("navegacion.html", "Modelo de Navegacion"),
			Node.new("interfaz.html", "Dise&ntilde;o de Interfaz"),
			Node.new("fs.html", "Jererarquia de Archivos")
		]),
		Node.new("pruebas.html", "Pruebas")
	]),
	Node.new("descargas.html", "Descargas"),
	Node.new("acercade.html", "Acerca De")
]

#print REFS[1].find_by_link("casosuso.html").top_node, "\n"

