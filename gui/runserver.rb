#! /usr/bin/env ruby

require 'webrick'

PORT = 7777

server = WEBrick::HTTPServer.new :Port => PORT
server.mount("/", WEBrick::HTTPServlet::FileHandler, "./", true)
server.mount_proc("/cgi/fs.cgi") { |rq, resp| p rq.body }
["INT", "TERM" ].each { |signal| trap(signal) { server.shutdown; exit! } }

puts "=> Escuchando en http://127.0.0.1:#{PORT}"
puts "=> Ctrl-C para terminar"

server.start
