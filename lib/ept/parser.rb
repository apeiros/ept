# encoding: utf-8



require 'bigdecimal'
require 'date'



module Ept
  class SyntaxError < StandardError; end

  module Parser
    DefaultMeta = {
      column_separator: /\|/,
      record_separator: /\n/,
      headers:          true,
      types:            false,
      name:             nil,
    }
    MetaName = {
      "Column-Separator" => :column_separator,
      "Record-Separator" => :record_separator,
      "Headers"          => :headers,
      "Types"            => :types,
      "Name"             => :name,
    }
    Boolean   = {'true' => true, 'false' => false}
    Separator = Hash.new { |hash, hex| # TODO: enable encodings; special case tab and space
      hash[hex] = /#{Regexp.escape([hex].pack("H*").force_encoding(Encoding::UTF_8))}/
    }.merge({
      ';'         => /;/,
      ','         => /,/,
      '|'         => /\|/,
      'tab'       => /\t/,
      'auto-crlf' => /\r?\n/,
      'crlf'      => /\r\n/,
      'lf'        => /\n/,
      'tab'       => /\t/,
      'none'      => nil,
    })
    Constructors = {
      date_time: Time.method(:mktime),
      date:      Date.method(:civil),
      time:      lambda { |hour,minute,second| now=Time.now; Time.mktime(now.year, now.month, now.day, hour, minute, second) },
      float:     Kernel.method(:Float),
      currency:  Kernel.method(:BigDecimal),
      decimal:   Kernel.method(:BigDecimal),
      octal:     Kernel.method(:Integer),
      hex:       Kernel.method(:Integer),
      binary:    Kernel.method(:Integer),
    }
  end
end
