Dir["./tasks/*"].sort.each { |ext| load ext }

desc "Record de todos los cambios y empaqueta"
task :sync => ["darcs:full_record", "pack:pack"]
	
