# encoding: utf-8



require 'ept/parser/expressions'
require 'bigdecimal'
require 'date'



module Ept
  module Parser

    # @private
    # Internal class, used to parse tables within documents
    class Table
      include Ept::Parser::Expressions

      attr_reader :scanner, :properties, :table, :row
      def initialize(scanner, bare_string, column_separator, record_boundary, constructors)
        @scanner          = scanner
        @bare_string      = bare_string
        @column_separator = column_separator
        @record_boundary  = record_boundary
        @constructors     = constructors
      end

      def parse
        @table = []
        while row = scan_row
          @table << row
        end

        @table
      end

      def scan_row
        true while @scanner.scan(RComment)
        return nil if @scanner.eos?

        value = scan_value
        @scanner.scan(/[ \t]*/)

        if value == :end_of_record
          nil
        else
          @row = [value]

          while scan_column_separator
            value = scan_value
            raise "Unexpected end" if :end_of_record.equal?(value)
            @row << value
            @scanner.scan(/[ \t]*/)
          end
          raise "Expected end of record" unless @scanner.eos? || (scan_value == :end_of_record)

          @row
        end
      end

      def scan_column_separator
        @column_separator ? @scanner.scan(@column_separator) : !@scanner.match?(@record_boundary)
      end

      def scan_value
        @scanner.scan(/[ \t]*/)
        case
          when @scanner.scan(RNil)             then nil
          when @scanner.scan(RTrue)            then true
          when @scanner.scan(RFalse)           then false
          when @scanner.scan(RDateTime)        then @constructors[:date_time].call(@scanner[1], @scanner[2], @scanner[3], @scanner[4], @scanner[5], @scanner[6])
          when @scanner.scan(RDate)            then @constructors[:date].call(@scanner[1].to_i, @scanner[2].to_i, @scanner[3].to_i)
          when @scanner.scan(RTime)            then @constructors[:time].call(@scanner[1].to_i, @scanner[2].to_i, @scanner[3].to_i)
          when @scanner.scan(RFloat)           then @constructors[:float].call(@scanner.matched.delete('^0-9.e-'))
          when @scanner.scan(RCurrency)        then @constructors[:currency].call(@scanner.matched.delete('^0-9.-'))
          when @scanner.scan(RBigDecimal)      then @constructors[:decimal].call(@scanner.matched.delete('^0-9.-'))
          when @scanner.scan(ROctalInteger)    then @constructors[:octal].call(@scanner.matched.delete('^0-9-'))
          when @scanner.scan(RHexInteger)      then @constructors[:hex].call(@scanner.matched.delete('^xX0-9A-Fa-f-'))
          when @scanner.scan(RBinaryInteger)   then @constructors[:binary].call(@scanner.matched.delete('^bB01-'))
          when @scanner.scan(RInteger)         then @scanner.matched.delete('^0-9-').to_i
          when @scanner.scan(RSString)         then @scanner.matched[1..-2].gsub(/\\'/, "'").gsub(/\\\\/, "\\")
          when @scanner.scan(RDString)         then @scanner.matched[1..-2].gsub(/\\(?:[0-3]?\d\d?|x[A-Fa-f\d]{2}|.)/) { |m| DStringEscapes[m] }
          when @scanner.scan(@bare_string)     then @scanner.matched.strip
          when @scanner.scan(@record_boundary) then :end_of_record
          else raise SyntaxError, "Unrecognized pattern: #{@scanner.rest.inspect}"
        end
      end
    end
  end
end
