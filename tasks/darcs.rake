namespace("darcs") do
	desc "Hace record de todos los cambios"
	task :full_record => ["check:in_project_dir?", "clean:clean"] do
		next_version = 0
		xml = IO.popen("darcs changes --xml-output --last 1").read
		if r = /.*<name>([0-9]*)<\/name>.*/.match(xml) and r[1]
			next_version = r[1].to_i+1
		end
		
		system("darcs add -r . -q")
		system("darcs record --edit-long-comment -a -m #{next_version}")
	end
	
	desc "Muestra la siguiente version de darcs"
	task :next_version => ["check:in_project_dir?"] do
		next_version = 0
		xml = IO.popen("darcs changes --xml-output --last 1").read
		if r = /.*<name>([0-9]*)<\/name>.*/.match(xml) and r[1]
			next_version = r[1].to_i+1
		end
		p next_version
	end
end

