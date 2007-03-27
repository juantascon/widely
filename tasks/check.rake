namespace("check") do
	desc "Check inicial"
	task :in_project_dir? do
		if ! File.directory?("_darcs")
			raise "_darcs no encontrado"
		end
	end
end

