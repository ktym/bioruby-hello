#!/usr/bin/env ruby
#
# = Bio::Hello -- Hello World plugin for the BioRuby (just for fun :-)
#
# Copyright::	Copyright (C) 2010 Toshiaki Katayama <mailto:k at bioruby dot org>
# License::	Distributes under the same terms as Ruby
# Site::	https://github.com/ktym/bioruby-hello
#
# == USAGE (AS A COMMAND)
#
# Usage:
#     % biohello.rb [options...] string
#     % biohello.rb [options...] file
# 
# Options:
#     -e or --encode
#        Encode the given string or file contents as a DNA sequence. (default)
#     -d or --decode
#        Decode a DNA encoded string.
#     -x or --helix
#        Show a DNA double strand helix in ASCII art.
#     -c or --code
#        Show the BioRuby code snippet.
#     -h or --help
#        Print this help message.
# 
# Examples:
#     % biohello.rb file
#     % biohello.rb -e file
#     % biohello.rb -d file
#
#     % biohello.rb "BioRuby is fun"
#     % biohello.rb -e "BIORUBY*IS*FUN"
#     % biohello.rb -d "nacatatagagatganactattaaataagttaattttgaaat"
#
#     % biohello.rb -x "I love you"
#     % biohello.rb -x -e "I*LOVE*YOU"
#     % biohello.rb -x -d "atataattataggtagaataatattagtga"
#
#     % biohello.rb -c "A happy new year"
#     % biohello.rb -c -e "A*HAPPY*NEW*YEAR"
#     % biohello.rb -c -d "gcataacatgcacctccttattaaaatgaatggtaatatgaagcaaga"
#
# TODO:
#  * Generate a postcard image :-)
#

require 'rubygems'
require 'bio-hello'
require 'getoptlong'

def show_usage
  prog  = File.basename($0)
  usage = %Q[
Usage:
    % #{prog} \[options...\] string
    % #{prog} \[options...\] file

Options:
    -e or --encode
       Encode the given string or file contents as a DNA sequence. (default)
    -d or --decode
       Decode a DNA encoded string.
    -x or --helix
       Show a DNA double strand helix in ASCII art.
    -c or --code
       Show the BioRuby code snippet.
    -h or --help
       Print this help message.

Examples:
    % #{prog} file
    % #{prog} -e file
    % #{prog} -d file

    % #{prog} "BioRuby is fun"
    % #{prog} -e "BIORUBY*IS*FUN"
    % #{prog} -d "nacatatagagatganactattaaataagttaattttgaaat"

    % #{prog} -x "I love you"
    % #{prog} -x -e "I*LOVE*YOU"
    % #{prog} -x -d "atataattataggtagaataatattagtga"

    % #{prog} -c "A happy new year"
    % #{prog} -c -e "A*HAPPY*NEW*YEAR"
    % #{prog} -c -d "gcataacatgcacctccttattaaaatgaatggtaatatgaagcaaga"

]
  puts usage
  exit
end

$opts = Hash.new

args = GetoptLong.new(
  [ '--encode',    '-e',  GetoptLong::NO_ARGUMENT ],
  [ '--decode',    '-d',  GetoptLong::NO_ARGUMENT ],
  [ '--helix',     '-x',  GetoptLong::NO_ARGUMENT ],
  [ '--code',      '-c',  GetoptLong::NO_ARGUMENT ],
  [ '--help',      '-h',  GetoptLong::NO_ARGUMENT ]
)

args.each_option do |name, value|
  case name
  when /--encode/
    $opts[:encode] = true
  when /--decode/
    $opts[:decode] = true
  when /--code/
    $opts[:code] = true
  when /--helix/
    $opts[:helix] = true
  when /--help/
    show_usage
  end
end

def process(string)
  if $opts[:decode]
    puts $hello.decode(string)
  else # default incl. $opts[:encode]
    puts $hello.encode(string)
  end
  if $opts[:helix]
    puts
    puts $hello.helix(string)
  end
  if $opts[:code]
    puts
    puts %Q[% ruby -rubygems -r bio -e 'p Bio::Sequence::NA.new("#{$hello.na}").translate']
    puts %Q[ ==> "#{$hello.aa}"]
    puts
  end
end


$hello = Bio::Hello.new

message = ARGV.first

if message and ! File.file?(message)
  process(message)
else
  ARGF.each do |line|
    process(line)
  end
end



=begin

hello = Bio::Hello.new(message)

puts hello.encode
puts Bio::Sequence::NA.new(hello.encode).translate
puts hello.decode(hello.encode)

aa = "BIO*RUBY*IS*FUN"
puts dna = hello.encode(aa)
puts hello.helix(aa)
puts hello.decode(dna)
puts hello.helix(dna)

puts Bio::Hello.encode("I*LOVE*YOU")
puts Bio::Hello.decode("atataattataggtagaataatattagtga")

ARGF.each do |line|
  puts hello.encode(line)
end

=end



