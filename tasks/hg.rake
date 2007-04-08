namespace("hg") do
	desc "Hace record de todos los cambios"
	task :full_commit => ["check:in_project_dir?", "clean:clean"] do
		system("hg commit -A")
	end
end

