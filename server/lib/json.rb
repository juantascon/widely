#
# JSON Objects
#  Copyright (C) 2003,2005 Rafael R. Sevilla <dido@imperium.ph>
#  This file is part of JSON for Ruby
#
#  JSON for Ruby is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public License
#  as published by the Free Software Foundation; either version 2.1 of
#  the License, or (at your option) any later version.
#
#  JSON for Ruby is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details. 
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with JSON for Ruby; if not, write to the Free
#  Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
#  02111-1307 USA.
#
# Author:: Rafael R. Sevilla (mailto:dido@imperium.ph)
# Heavily modified by Adam Kramer (mailto:adam@the-kramers.net)
# Copyright:: Copyright (c) 2003,2005 Rafael R. Sevilla
# License:: GNU Lesser General Public License
# $Id: objects.rb,v 1.2 2006/02/08 20:02:23 tmyrtle Exp $
#


class Object
  def to_json #all strings in json need to have double quotes around them, treat random objects as strings
    String.to_json(to_s)
  end
end


class NilClass
  def to_json
    "null"
  end
end
class TrueClass
  def to_json
    "true"
  end
end

class FalseClass
  def to_json
    "false"
  end
end

class Numeric
  def to_json
    to_s
  end
end

class String
    # produce a string in double quotes with all the necessary quoting
    # done
    def to_json
      return String.to_json(self)
    end

    def self.to_json(str)
      return "\"\"" if (str.length == 0)
      newstr = "\""
      str.each_byte {
	|b|
	c = b.chr
	case c
	when /\\|\"|\//
	  newstr << "\\" + c
	when "\b"
	  newstr << "\\b"
	when "\t"
	  newstr << "\\t"
	when "\n"
	  newstr << "\\n"
	when "\f"
	  newstr << "\\f"
	when "\r"
	  newstr << "\\r"
	else
	  if (c < ' ')
	    t = "000" + sprintf("%0x", b)
	    newstr << ("\\u" + t[0,t.length - 4])
	  else
	    newstr << c
	  end
	end
      }
      newstr += '"'
      return(newstr)
    end
end

class Array

    # This method will return a string giving the contents of the JSON
    # array in standard JSON format.
    def to_json
      retval = '['

      first=true
      self.each { |obj|
	retval << ',' unless first
	retval << obj.to_json
	first=false
      }
      retval << "]"
      return(retval)
    end

    # This method will parse a JSON array from the passed lexer
    # object.  It takes a lexer object which is about to read a JSON
    # array.  It raises a runtime error otherwise.  It returns the
    # original JSON array. This method is not intended to be used
    # directly.
    # =====Parameters
    # +lexer+:: Lexer object to use
    def from_json(lexer)
      raise "A JSON Array must begin with '['" if (lexer.nextclean != "[")
      return (self) if lexer.nextclean == ']'
      lexer.back
      loop {
	self << lexer.nextvalue
	case lexer.nextclean
	when ','
	  return if (lexer.nextclean == ']')
	  lexer.back
	when ']'
	  return(self)
	else
	  raise "Expected a ',' or ']'"
	end
      }
    end
end




class Hash

    # This method will serialize the hash into regular JSON format.
    def to_json
      retval = "{"

      first = true
      self.each {|key, val|
 	retval << "," unless first
	key = key.to_s #keys in json hashes need to be strings, nothing else.
 	retval << key.to_json + ":"
 	retval << val.to_json
	first = false
      }
      retval << "}"
      return(retval)
    end

    # This method will parse a JSON object from the passed lexer
    # object.  It takes a lexer object which is about to read a JSON
    # object.  It raises a runtime error otherwise.  It returns the
    # original JSON object.  This method probably shouldn't be used
    # directly.
    # =====Parameters
    def from_json(lexer)
      lexer.unescape if (lexer.nextclean == '%')
      lexer.back
      raise "A JSON Object must begin with '{'" if (lexer.nextclean != "{")
      loop {
	c = lexer.nextclean
	key = nil
	case c
	when '\0'
	  raise "A JSON Object must end with '}'"
	when '}'
	  return (self);
	else
	  lexer.back
	  key = lexer.nextvalue().to_s()
	end
	raise "Expected a ':' after a key" if (lexer.nextclean() != ':')
	self[key] = lexer.nextvalue()
	case lexer.nextclean()
	when ','
	  return if (lexer.nextclean() == '}')
	  lexer.back
	when '}'
	  return(self)
	else
	  raise "Expected a ',' or '}'"
	end
      }
      return(self)
    end

end

#
# Lexical analyzer for JSON
#  Copyright (C) 2003,2005 Rafael R. Sevilla <dido@imperium.ph>
#  This file is part of JSON for Ruby
#
#  JSON for Ruby is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public License
#  as published by the Free Software Foundation; either version 2.1 of
#  the License, or (at your option) any later version.
#
#  JSON for Ruby is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details. 
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with JSON for Ruby; if not, write to the Free
#  Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
#  02111-1307 USA.
#
# Author:: Rafael R. Sevilla (mailto:dido@imperium.ph)
# Some bugs fixed by Adam Kramer (mailto:adam@the-kramers.net)
# Copyright:: Copyright (c) 2003,2005 Rafael R. Sevilla
# License:: GNU Lesser General Public License
# $Id: lexer.rb,v 1.8 2006/02/09 18:14:20 tmyrtle Exp $
#
require 'cgi'

module JSON

  VERSION = '1.1.2'
  
  class Lexer
    # This method will initialize the lexer to contain a string.
    # =====Parameters
    # +s+:: the string to initialize the lexer object with
    def initialize(s)
      @index = 0
      @source = s
    end

    # Backs up the lexer status one character.
    def back
      @index -= 1 if @index > 0
    end

    def more?
      return(@index < @source.length)
    end

    # Consumes the next character.
    def nextchar
      c = self.more?() ? @source[@index,1] : "\0"
      @index += 1
      return(c)
    end

    # Consumes the next character and check that it matches a specified
    # character.
    def nextmatch(char)
      n = self.nextchar
      raise "Expected '#{char}' and instead saw '#{n}'." if (n != char)
      return(n)
    end

    # Read the next n characters from the string in the lexer.
    # =====Parameters
    # +n+:: the number of characters to read from the lexer
    def nextchars(n)
      raise "substring bounds error" if (@index + n > @source.length)
      i = @index
      @index += n
      return(@source[i,n])
    end

    # Read the next n characters from the string with escape sequence
    # processing.
    def nextclean
      while true
	c = self.nextchar()
	if (c == '/')
	  case self.nextchar()
	  when '/'
	    c = self.nextchar()
	    while c != "\n" && c != "\r" && c != "\0"
	      c = self.nextchar()
	    end
	  when '*'
	    while true
	      c = self.nextchar()
	      raise "unclosed comment" if (c == "\0")
	      if (c == '*')
		break if (self.nextchar() == '/')
		self.back()
	      end
	    end
	  else
	    self.back()
	    return '/';
	  end
	elsif c == "\0" || c[0] > " "[0]
	  return(c)
	end
      end
    end

    # Given a Unicode code point, return a string giving its UTF-8
    # representation based on RFC 2279.
    def utf8str(code)
      if (code & ~(0x7f)) == 0
        # UCS-4 range 0x00000000 - 0x0000007F
        return(code.chr)
      end

      buf = ""
      if (code & ~(0x7ff)) == 0
        # UCS-4 range 0x00000080 - 0x000007FF
        buf << (0b11000000 | (code >> 6)).chr
        buf << (0b10000000 | (code & 0b00111111)).chr
        return(buf)
      end

      if (code & ~(0x000ffff)) == 0
        # UCS-4 range 0x00000800 - 0x0000FFFF
        buf << (0b11100000 | (code >> 12)).chr
        buf << (0b10000000 | ((code >> 6) & 0b00111111)).chr
        buf << (0b10000000 | (code & 0b0011111)).chr
        return(buf)
      end

      # Not used -- JSON only has UCS-2, but for the sake
      # of completeness
      if (code & ~(0x1FFFFF)) == 0
        # UCS-4 range 0x00010000 - 0x001FFFFF
        buf << (0b11110000 | (code >> 18)).chr
        buf << (0b10000000 | ((code >> 12) & 0b00111111)).chr
        buf << (0b10000000 | ((code >> 6) & 0b00111111)).chr
        buf << (0b10000000 | (code & 0b0011111)).chr
        return(buf)
      end

      if (code & ~(0x03FFFFFF)) == 0
        # UCS-4 range 0x00200000 - 0x03FFFFFF
        buf << (0b11110000 | (code >> 24)).chr
        buf << (0b10000000 | ((code >> 18) & 0b00111111)).chr
        buf << (0b10000000 | ((code >> 12) & 0b00111111)).chr
        buf << (0b10000000 | ((code >> 6) & 0b00111111)).chr
        buf << (0b10000000 | (code & 0b0011111)).chr
        return(buf)
      end

      # UCS-4 range 0x04000000 - 0x7FFFFFFF
      buf << (0b11111000 | (code >> 30)).chr
      buf << (0b10000000 | ((code >> 24) & 0b00111111)).chr
      buf << (0b10000000 | ((code >> 18) & 0b00111111)).chr
      buf << (0b10000000 | ((code >> 12) & 0b00111111)).chr
      buf << (0b10000000 | ((code >> 6) & 0b00111111)).chr
      buf << (0b10000000 | (code & 0b0011111)).chr
      return(buf)
    end

    # Reads the next string, given a quote character (usually ' or ")
    # =====Parameters
    # +quot+: the next matching quote character to use
    def nextstring(quot)
      c = buf = ""
      while true
	c = self.nextchar()
	case c
	when /\0|\n\r/
	  raise "Unterminated string"
	when "\\"
	  chr = self.nextchar()
	  case chr
	  when 'b'
	    buf << "\b"
	  when 't'
	    buf << "\t"
	  when 'n'
	    buf << "\n"
	  when 'f'
	    buf << "\f"
	  when 'r'
	    buf << "\r"
	  when 'u'
	    buf << utf8str(Integer("0x" + self.nextchars(4)))
	  else
	    buf << chr
	  end
	else
	  return(buf) if (c == quot)
	  buf << c
	end
      end
    end

    # Reads the next group of characters that match a regular
    # expresion.
    # 
    def nextto(regex)
      buf = ""
      while (true)
	c = self.nextchar()
	if !(regex =~ c).nil? || c == '\0' || c == '\n' || c == '\r'
	  self.back() if (c != '\0')
	  return(buf.chomp())
	end
	buf += c
      end
    end

    # Reads the next value from the string.  This can return either a
    # string, a FixNum, a floating point value, a JSON array, or a
    # JSON object.
    def nextvalue
      c = self.nextclean
      s = ""

      case c
      when /\"|\'/
	return(self.nextstring(c))
      when '{'
	self.back()
        return(Hash.new.from_json(self))
      when '['
	self.back()
	return(Array.new.from_json(self))
      else
	buf = ""
	while ((c =~ /"| |:|,|\]|\}|\/|\0/).nil?)
	  buf += c
	  c = self.nextchar()
	end
	self.back()
	s = buf.chomp
	case s
	when "true"
	  return(true)
	when "false"
	  return(false)
	when "null"
	  return(nil)
	when /^[0-9]|\.|-|\+/
	  begin
	    return(Integer(s))
	  rescue ArgumentError
	    # do nothing on an error, the next case should do the trick
	  end
	  begin
	    return(Float(s))
	  rescue ArgumentError
	    # do nothing
	  end
	end
	if (s == "")
          s = nil
        end
	return(s)
      end
    end

    # Skip to the next instance of the character specified
    # =====Parameters
    # +to+:: Character to skip to
    def skipto(to)
      index = @index
      loop {
	c = self.nextchar()
	if (c == '\0')
	  @index = index
	  return(c)
	end
	if (c == to)
	  self.back
	  return(c)
	end
      }
    end

    def unescape
      @source = CGI::unescape(@source)
    end

    # Skip past the next instance of the character specified
    # =====Parameters
    # +to+:: the character to skip past
    def skippast(to)
      @index = @source.index(to, @index)
      @index = (@index.nil?) ? @source.length : @index + to.length
    end

    def each
      while (n = nextvalue)
        yield(n)
      end
    end
  end
end

