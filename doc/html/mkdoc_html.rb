#! /usr/bin/env ruby

if ARGV[0]
	PREFIX_OUTPUT_DIR = "#{ARGV[0]}/"
else
	PREFIX_OUTPUT_DIR = "./output/"
end

$: << File.dirname($0)
PREFIX_HTML_PARTIAL_FILE = "#{File.dirname $0}/html-partials/"
PREFIX_SUBMENU_FILE = "#{PREFIX_HTML_PARTIAL_FILE}submenu_"

require "template.rb"

def html_to_file(nodes)
	nodes.each do |n|
		t = HTMLTemplate.new(n.link)
		
		stdout_old = $stdout
		$stdout = File.new(PREFIX_OUTPUT_DIR+n.link, File::CREAT|File::TRUNC|File::RDWR)
		t.create_html()
		$stdout = stdout_old
		
		html_to_file(n.sub_nodes) if !n.sub_nodes.nil?
	end
end

if ! File.directory? PREFIX_OUTPUT_DIR
	print "ERROR -- no existe: #{PREFIX_OUTPUT_DIR}"
	exit
end

html_to_file(REFS)

