#! /usr/bin/env ruby

def start_server(port, dispatcher)
	require 'webrick'
	
	server = WEBrick::HTTPServer.new :Port => port
	server.mount("/", WEBrick::HTTPServlet::CGIHandler, dispatcher)
	
	["INT", "TERM" ].each { |signal| trap(signal) { server.shutdown } }
	
	puts "=> Escuchando en http://127.0.0.1:#{port}"
	puts "=> Ctrl-C para terminar"
	
	server.start
end

