# Manejo de un repositorio con subversion(svn)
# todo:
# status()
# ls(): crear un filetree

module Svn
class RepositorySvn < Repository::Base
	require "rexml/document.rb"
	
	attr_reader :dir_path, :dir
	
	def initialize(dir)
		@dir = dir
		@dir_path = Pathname.new(@dir)
		we_warn("#{@dir} -> not an absolute path") if ! @dir_path.absolute?
	end
	
	def exists()
		if ( @dir_path.directory? \
			and (@dir_path+"format").file? \
			and (@dir_path+"README.txt").file? \
			and (@dir_path+"db"+"fs-type").file? )
			return true
		end
		return false
	end
	
	def create()
		w_info("#{@dir}")
		cmd = Command.exec("svnadmin", "create", @dir)
		return true if cmd.status.success?
		w_warn("Fail -- #{cmd.stderr}")
		return false
	end
	
	
	def checkout(wc_dir, version=versions.last)
		w_info("#{@dir}@#{version.get} -> #{wc_dir}")
		cmd = Command.exec("svn", "checkout", "file://#{@dir}@#{version.get}", wc_dir)
		return true if cmd.status.success?
		w_warn("Fail -- #{cmd.stderr}")
		return false
	end
	
	def cat(path, version=versions.last)
		w_info("#{path}@#{version.get}")
		realpath = Pathname.new(path).cleanpath
		(w_warn("#{path} -> not an absolute path") ; return false ) if ! realpath.absolute?
		
		cmd = Command.exec("svn", "cat", "file://#{@dir}/#{realpath.to_s}@#{version.get}")
		return cmd.stdout if cmd.status.success?
		w_warn("Fail -- #{cmd.stderr}")
		return false
	end
	
	def ls(path, version = self.versions.last)
		w_info("#{path}@#{version.get}")
		realpath = Pathname.new(path).cleanpath
		(w_warn("#{path} -> not an absolute path") ; return false ) if ! realpath.absolute?
		
		cmd = Command.exec("svn", "ls", "file://#{@dir}/#{realpath.to_s}@#{version.get}")
		return cmd.stdout if cmd.status.success?
		w_warn("Fail -- #{cmd.stderr}")
		return false
	end
	
	
	def status(wc_dir)
		w_info("#{wc_dir}")
		@context.status(wc_dir)
	end
	
	def commit(wc_dir, log)
		w_info("#{wc_dir}(#{log}) -> #{@dir}:")
		cmd = Command.exec("svn", "commit", "--non-interactive", "-m", log, wc_dir)
		return true if cmd.status.success?
		w_warn("Fail -- #{cmd.stderr}")
		return false
	end
	
	
	def add(wc_dir, path)
		w_info("#{wc_dir}:#{path}")
		realpath = Pathname.new(path).cleanpath
		(w_warn("#{path} -> not an absolute path") ; return false ) if ! realpath.absolute?
		
		cmd = Command.exec("svn", "add", "-N", "#{wc_dir}/#{realpath.to_s}")
		return true if cmd.status.success?
		w_warn("Fail -- #{cmd.stderr}")
		return false
	end
	
	def delete(wc_dir, path)
		w_info("#{wc_dir}:#{path}")
		realpath = Pathname.new(path).cleanpath
		(w_warn("#{path} -> not an absolute path") ; return false ) if ! realpath.absolute?
		
		cmd = Command.exec("svn", "delete", "#{wc_dir}/#{realpath.to_s}")
		return true if cmd.status.success?
		w_warn("Fail -- #{cmd.stderr}")
		return false
	end
	
	def move(wc_dir, path_from, path_to)
		w_info("#{wc_dir}: #{path_from} -> #{path_to}")
		realpath_from = Pathname.new(path_from).cleanpath
		realpath_to = Pathname.new(path_to).cleanpath
		(w_warn("#{path_from} -> not an absolute path") ; return false ) if ! realpath_from.absolute?
		(w_warn("#{path_to} -> not an absolute path") ; return false ) if ! realpath_to.absolute?
		
		cmd = Command.exec("svn", "move", "#{wc_dir}/#{realpath_from.to_s}", "#{wc_dir}/#{realpath_to.to_s}")
		return true if cmd.status.success?
		w_warn("Fail -- #{cmd.stderr}")
		return false
	end
	
	
	def versions()
		w_info("#{@dir}")
		cmd = Command.exec("svn", "log", "--xml", "file://#{@dir}")
		( w_warn("Fail -- #{cmd.stderr}"); return false ) if ! cmd.status.success?
		
		ret = Array.new
		doc = REXML::Document.new(cmd.stdout)
		doc.root.each_element do |version|
			ret.push( Repository::Version.new(
				version.attribute("revision").to_s,
				version.get_text("msg"),
				version.get_text("date"),
				version.get_text("author") ))
		end
		ret.push(Repository::Version.new(0))
		return ret.reverse
	end
end
end
