# encoding: utf-8



require 'strscan'
require 'bigdecimal'



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
      ';'     => /;/,
      ','     => /,/,
      '|'     => /\|/,
      'tab'   => /\t/,
      'auto'  => /\r?\n/,
      'crlf'  => /\r\n/,
      'lf'    => /\n/,
      'tab'   => /\t/,
      'none'  => nil,
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

    attr_reader :processor, :source, :scanner, :state, :can_continue,
                :properties, :encoding, :column_separator, :record_separator,
                :table_head_pattern, :headers

    def initialize(source='', properties=nil, &processor)
      raise ArgumentError, "No block given" unless processor
      @now                   = Time.now # needed for Time
      @processor             = processor
      @source                = source
      @scanner               = StringScanner.new(@source)
      @literals              = LiteralParser.new(@source, attach: @scanner, use_big_decimal: true)
      @state                 = :encoding
      @can_continue          = true
      @properties            = DefaultProperties.dup
      @encoding              = nil
      @column_separator      = nil
      @record_separator      = nil
      @headers               = nil
      @current_table         = nil
      @big_decimal_converter = @use_big_decimal ? Kernel.method(:BigDecimal) : Kernel.method(:Float)
    end


    def process_properties
      @encoding           = Encoding.find(@properties[:encoding])
      @column_separator   = /#{Regexp.escape([@properties[:column_separator]].pack("H*").force_encoding(@encoding))}/
      @record_separator   = /#{Regexp.escape([@properties[:record_separator]].pack("H*").force_encoding(@encoding))}/
      @headers            = Boolean.fetch(@properties[:headers]) { raise "Illegal value for headers" }
      @table_head_pattern = /#{TableHeadPattern}#{@record_separator}/
      @current_table      = {
        headers: @headers,
        name:    nil,
      }
      @source.force_encoding(@encoding)
    end
  end
end
