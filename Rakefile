Dir["./tasks/*"].sort.each { |ext| load ext }

desc "Record de todos los cambios y empaqueta"
task :sync => ["hg:full_commit", "pack:pack"]

