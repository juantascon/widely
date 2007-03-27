namespace("pack") do
	project = File.basename(Dir.pwd)
	
	desc "Distribuye la aplicacion"
	task :pack => ["check:in_project_dir?"] do
		t = Time.now
		date = "#{t.year}#{t.month.to_s.rjust(2, '0')}#{t.day.to_s.rjust(2, '0')}"
		secs = ((t.hour*360) + (t.min*60) + (t.sec)).to_s
		from = "../#{project}"
		to = "../#{project}-#{date}-#{secs}.tar.bz2"
		print "Packing: #{to} ... "
		if ! system("tar cfj #{to} #{from} 2>/dev/null")
			raise "ERROR -- empaquetando"
		end
		print "OK\n"
	end
end

