#! /usr/bin/env ruby

require "json"
require "cgi"

cgi = CGI.new()
cgi.out do
	"<textarea id=\"editarea\">hola2</textarea>"
end

