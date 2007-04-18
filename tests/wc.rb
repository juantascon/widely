at_exit do
	print "Limpiando\n"
	Dir.glob("/tmp/{repos*,wc*}").each { |d| FileUtils.rm_rf d }
end

repos = Repository::Repository.new(:svn, "/tmp/repos");
wc = WorkingCopy.new("/tmp/wc", repos)
wc2 = WorkingCopy.new("/tmp/wc2", repos)

wc.checkout
wc.add("/testfile1")
wc.write("/testfile1", "hola ve")
wc.commit("version1")

wc.write("/testfile1", "bien o que ve")
p wc.cat("/testfile1")
p wc.cat("/testfile1", wc.versions.last)

wc.add("/dir1", true)
wc.add("/dir2", true)
wc.add("/dir1/dir1_1", true)
wc.add("/dir1/dir1_2", true)
wc.add("/../../../../..", true)
wc.delete("/../../../../..")

wc.add("/dir1/dir1_1/testfile2")
wc.write("/dir1/dir1_1/testfile2", "deepfile")
wc.commit("version2")

wc.move("/dir1/dir1_1/testfile2", "/dir1/dir1_2")
wc.delete("/dir1/dir1_1")
wc.commit("version3")
p wc.versions
p wc.ls("/").root.to_s
p wc.ls("/", wc.versions.last).root.to_s

gets
