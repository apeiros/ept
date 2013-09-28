# encoding: utf-8



module Ept
  module Parser

    # @private
    # All the expressions used to parse the literals
    # Ept::Parser::Expressions.bare_string
    module Expressions
      def self.bare_string(column_separator, record_separator)
        if column_separator
          /\p{Letter}(?:(?!#{column_separator}|#{record_separator})[^\\]|\\.)*/m
        else
          /\p{Letter}(?:(?!#{record_separator})[^\\]|\\.)*/m
        end
      end

      hex2            = /[0-9A-Fa-f]{2}/

      REncoding       = /\% Encoding: +([^\r\n ]+)\r?\n/

      RMeta           = /\% (Column-Separator|Record-Separator|Headers|Types|Name): +([,;|]|tab|none|true|false|lf|crlf|(?:#{hex2})+|\p{Letter}+)\r?\n/i

      REmptyLine      = /[ \t]*\r?\n/

      RComment        = /[ \t]*\#[^\r\n]*/

      RNil            = /\+null|\-/                              # Match nil

      RFalse          = /\+false/                                # Match false

      RTrue           = /\+true/                                 # Match true

      RInteger        = /[+-]?\d[\d_]*/                          # Match an Integer in decimal notation

      RBinaryInteger  = /[+-]?0b[01][01_]*/                      # Match an Integer in binary notation

      RHexInteger     = /[+-]?0x[A-Fa-f\d][A-Fa-f\d_]*/          # Match an Integer in hexadecimal notation

      ROctalInteger   = /[+-]?0[0-7][0-7'_,]*/                   # Match an Integer in octal notation

      RBigDecimal     = /#{RInteger}\.\d+/                       # Match a decimal number (Float or BigDecimal)

      RCurrency       = /#{RBigDecimal}\$/                       # Match a currency (uses BigDecimal)

      RFloat          = /#{RBigDecimal}(?:f|e#{RInteger})/       # Match a decimal number in scientific notation

      RSString        = /'(?:[^\\']+|\\.)*'/m                    # Match a single quoted string

      RDString        = /"(?:[^\\"]+|\\.)*"/m                    # Match a double quoted string

      RDate           = /(\d{4})-(\d{2})-(\d{2})/                # Match a date

      RTimeZone       = /(Z|[A-Z]{3,4}|[+-]\d{4})/               # Match a timezone

      RTime           = /(\d{2}):(\d{2}):(\d{2})(?:RTimeZone)?/  # Match a time (without date)

      RDateTime       = /#{RDate}T#{RTime}/                      # Match a datetime

      # Map escape sequences in double quoted strings
      DStringEscapes  = {
        '\\\\' => "\\",
        "\\'"  => "'",
        '\\"'  => '"',
        '\t'   => "\t",
        '\f'   => "\f",
        '\r'   => "\r",
        '\n'   => "\n",
      }
      256.times do |i|
        DStringEscapes["\\%o" % i]    = i.chr
        DStringEscapes["\\%03o" % i]  = i.chr
        DStringEscapes["\\x%02x" % i] = i.chr
        DStringEscapes["\\x%02X" % i] = i.chr
      end
    end
  end
end
