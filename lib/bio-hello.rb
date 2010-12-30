#
# = Bio::Hello -- Hello World plugin for the BioRuby (just for fun :-)
#
# Copyright::	Copyright (C) 2010 Toshiaki Katayama <mailto:k at bioruby dot org>
# License::	Distributes under the same terms as Ruby
# Site::	https://github.com/ktym/bioruby-hello
#
# == USAGE (AS A LIBRARY)
# 
# The Bio::Hello class accepts your message as an amino acid sequence
# and encodes it as a DNA sequence.
#
# As this http://twitter.com/#!/OrthoNormalRuss/status/19117017042784256
# example shows,
#
#   seq = Bio::Sequence::NA.new("ATGGAGCGTCGTTATTAATGTCATCGTATTTCTACTATGGCTTCT")
#   puts seq.translate
#
# the translation itself is originally supported by the BioRuby library,
# however, this plugin provides both encoding and decoding of the message.
#
# Reverse translation of a given string into a DNA sequence can be done
# by the following script
#
#   require 'rubygems'
#   require 'bio'
#
#   ct = Bio::CodonTable[1]
#   aa = Bio::Sequence::AA("A*HAPPY*NEW*YEAR")
#   na = aa.split(//).map{|a| ct.revtrans(a).first}.join
#
# and can be confirmed by the following bioruby shell session.
#
#   bioruby> ct = codontable(1)
#   bioruby> aa = getseq("A*HAPPY*NEW*YEAR")
#     ==> A*HAPPY*NEW*YEAR
#   bioruby> na = aa.split(//).map{|a| ct.revtrans(a).first}.join
#     ==> "gcataacatgcacctccttattaaaatgaatggtaatatgaagcaaga"
#
# However, this method won't work for "I*LOVE*YOU" as the message contains 
# abnormal amino acids like pyrrolysine and selenocysteine.
#
# Therefore, this plugin also provides ad hoc support for all 26 alphabets,
# which enables you to encode any message as a DNA sequence.
#
# Bio::Hello.encode() and Bio::Hello.decode() can be used as class methods.
#
#    puts Bio::Hello.encode("I*LOVE*YOU")
#    puts Bio::Hello.decode("atataattataggtagaataatattagtga")
#
# You can also instantiate the Bio::Hello object to reduce the initialization cost.
#
#   hello = Bio::Hello.new(string)
#   puts hello.encode
#
#   puts hello.encode("BIO*RUBY*IS*FUN")
#
#   ARGF.each do |line|
#     puts hello.encode(line)
#   end
# 

require 'rubygems'
require 'bio'

module Bio

class Hello

  attr_reader :message

  def initialize(string = nil)
    @message = string || "HELLO*BIORUBY"
    @aa = clean_aaseq(@message)
    @ct = codon_table
  end

  def clean_aaseq(string = "")
    string.upcase.gsub(/[^A-Z]+/, ' ').strip.tr(' ', '*')
  end

  # ad hoc modifications to support 26 alphabets
  # (only confirmed with the codon table 1)
  def codon_table
    ct = Bio::CodonTable.copy(1)

    # O Pyl pyrrolysine
    ct['tag'] = 'O'

    # U Sec selenocysteine
    ct['tga'] = 'U'

    # B Asx asparagine/aspartic acid [DN]
    ct['nac'] = 'B'  # can be 'uac' (Y) or 'cac' (H) but please omit.
    
    # J Xle isoleucine/leucine [IL]
    ct['ctn'] = 'J'  # should also include 'tt[ag]' (L), 'at[tca]' (I).

    # Z Glx glutamine/glutamic acid [EQ]
    ct['nag'] = 'Z'  # can be 'aag' (K) or 'tag' (*/O) but please omit.

    # X Xaa unknown [A-Z]
    ct['nnn'] = 'X'

    ct['xxx'] = '.'

    return ct
  end

  def encode(string = nil)
    if string
      @message = string
      @aa = clean_aaseq(string)
    end
    na = @aa.split(//).map{|a| @ct.revtrans(a).first}.join
    @na = Bio::Sequence::NA.new(na)
  end

  def decode(string = nil)
    if string
      @na = Bio::Sequence::NA.new(string)
    end
    @na.translate(1, @ct)
  end

  def self.encode(string)
    self.new.encode(string)
  end

  def self.decode(string)
    self.new.decode(string)
  end

end # class Hello

end # module Bio


