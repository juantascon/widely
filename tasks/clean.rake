namespace("clean") do
	desc "Limpia los archivos innecesarios"
	task :clean => [ "check:in_project_dir?", :clean_backup, :clean_kdevelop, :clean_doc ]
	
	desc "Limpia los archivos de backup"
	task :clean_backup => "check:in_project_dir?" do
		rm_rf Dir.glob("**/*~")
	end
	
	desc "Limpia los archivos temporales de kdevelop"
	task :clean_kdevelop => "check:in_project_dir?" do
		rm_rf "widely.kdevses"
	end
	
	desc "Limpia los archivos temporales de la documentacion"
	task :clean_doc => [ "check:in_project_dir?", "doc:clean" ]
end

