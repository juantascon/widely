#! /usr/bin/env ruby

require "json"
require "cgi"

#$log = File.new("log", "w")

def file_type(file)
	return "folder" if File.directory? file
	return "file"
end

def file_list(dirname)
	list = [ ]
	Dir.foreach(dirname) do |filename|
		next if filename =~ /^\.{1,2}$/ #salte si es "." o ".."
		file = "#{dirname}/#{filename}"
		#$log.print "#{file}"
		list.insert(-1,
		{
			"text" => filename,
			"id" => file,
			"childs" => File.directory?(file) ? file_list(file) : false,
			"cls" => file_type(file)
		})
	end
	
	return list
end


cgi = CGI.new()
cgi.out do
	#file_list(cgi.params["node"][0]).to_json
	{"hola" => 3}.to_json
end

