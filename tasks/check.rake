namespace("check") do
	desc "Check inicial"
	task :in_project_dir? do
		if ! File.file?("licencia")
			raise "licencia no encontrado"
		end
	end
end

