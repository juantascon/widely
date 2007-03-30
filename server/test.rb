at_exit do
        print "Limpiando\n"
        Dir.glob("/tmp/{repos*,wc*}").each { |d| FileUtils.rm_rf d }
end

wc = "/tmp/wc"
repos = Svn::RepositorySvn.new("/tmp/repos");
repos.create
repos.checkout(wc)
f = File.new("#{wc}/testfile1", "w+"); f.print("hola\n"); f.close
repos.add(wc, "/testfile1")
repos.commit(wc, "version1")
p repos.cat("/testfile1")
f = File.new("#{wc}/testfile1", "w+"); f.print("bien?\n"); f.close
repos.commit(wc, "version2")
Dir.mkdir("#{wc}/dir1")
repos.add(wc, "/dir1")
Dir.mkdir("#{wc}/dir2")
repos.add(wc, "/dir2")
Dir.mkdir("#{wc}/dir1/dir1_1")
repos.add(wc, "/dir1/dir1_1")
Dir.mkdir("#{wc}/dir1/dir1_2")
repos.add(wc, "/dir1/dir1_2")
f = File.new("#{wc}/dir1/dir1_1/testfile2", "w+"); f.print("deep file\n"); f.close
repos.add(wc, "/dir1/dir1_1/testfile2")
repos.commit(wc, "version3")

p repos.ls("/")
gets
