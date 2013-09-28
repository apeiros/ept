# encoding: utf-8



require 'strscan'
require 'ept/parser'
require 'ept/parser/expressions'
require 'ept/parser/table'



module Ept
  module Parser

    class Document
      include Ept::Parser::Expressions

      attr_reader :encoding, :now, :source, :scanner

      # Attention! Ept::Parser::Document can change the .encoding of the string
      def initialize(source)
        @source       = source
        @now          = Time.now # needed for Time
        @encoding     = Encoding::UTF_8
        @current_meta = Ept::Parser::DefaultMeta.dup
        @scanner      = StringScanner.new(@source)
      end

      def parse
        @tables = []
        scan_encoding
        @source.force_encoding @encoding

        until @scanner.eos?
          true while (scan_meta || scan_empty_line)
          column_separator = @current_meta[:column_separator]
          record_separator = @current_meta[:record_separator]
          bare_string      = Ept::Parser::Expressions.bare_string(column_separator, record_separator)
          table_parser     = Ept::Parser::Table.new(@scanner, bare_string, column_separator, record_separator, Ept::Parser::Constructors)

          @tables << {meta: @current_meta.dup, data: table_parser.parse}
          @current_meta[:name] = nil # reset the name

          true while @scanner.scan(REmptyLine)
        end

        @tables
      end

      def scan_empty_line
        @scanner.scan(REmptyLine) || @scanner.scan(RComment)
      end

      def scan_encoding
        if @scanner.scan(REncoding)
          @encoding = Encoding.find(@scanner[1])
        end
      end

      def scan_meta
        if @scanner.scan(RMeta)
          name  = Ept::Parser::MetaName[@scanner[1]]
          value = case name
            when :column_separator then Ept::Parser::Separator[@scanner[2].downcase]
            when :record_separator then Ept::Parser::Separator[@scanner[2].downcase]
            when :headers          then Ept::Parser::Boolean[@scanner[2]]
            when :types            then Ept::Parser::Boolean[@scanner[2]]
            when :name             then @scanner[2]
            else raise "Invalid meta-key: #{@scanner[1]}"
          end
          @current_meta[name] = value

          true
        else
          false
        end
      end
    end
  end
end
