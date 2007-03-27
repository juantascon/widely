namespace("doc") do
	doc = "doc"
	output = "#{doc}/build"
	html = "#{doc}/html"
	html_output = "#{output}"
	css = "#{doc}/html/css"
	css_output = "#{output}/css"
	diags = "#{doc}/diagramas"
	diags_output = "#{output}/diagramas"
	
	desc "Construye toda la documentacion de desarollo"
	task :mkdoc => ["check:in_project_dir?", :clean, :css, :dia, :html]
	
	desc "Crea el directorio de salida"
	task :init do
		mkdir(output) if ! File.directory?(output)
	end
	
	desc "Limpia el directorio de salida"
	task :clean do
		FileUtils.rm_r(output) if File.directory?(output)
	end
	
	desc "Crea las plantillas CSS"
	task :css => [:init] do
		FileUtils.cp_r(css, css_output)
	end
	
	desc "Crea el contenido html"
	task :html => [:init] do
		system("ruby #{html}/mkdoc_html.rb #{html_output}")
	end
	
	desc "Convierte los diagramas (.dia) en imagenes (.png)"
	task :dia => [:init] do
		FileUtils.cp_r(diags, diags_output)
		
		Dir.entries(diags_output).each do |fname|
			f = "#{diags_output}/#{fname}"
			if ( File.extname(f) == ".dia" )
				system("dia -e #{f}.png #{f}")
			end
		end
	end
end

