ABNF for .ept files
===================

LF, CRLF, WSP, DIGIT, HEXDIG, VCHAR, OCTET and DQUOTE are defined by ABNF, see
http://en.wikipedia.org/wiki/Augmented_Backus–Naur_Form

    document          = [bom] [document_encoding] *table
    document_encoding = "% Encoding:" *WSP encoding_name newline
    table             = * (meta_datum / empty_line / comment) table_data
    table_data        = [header_row] *comment [types_row] *(row / comment)
    header_row        = row
    types_row         = row
    row               = cell *(*WSP column_separator *WSP cell)
                        (record_separator / end_of_document)

    bom               = (0xEF 0xBB 0xBF) /      ; UTF-8
                        (0xFE 0xFF) /           ; UTF-16-BE
                        (0xFF 0xFE) /           ; UTF-16-LE
                        (0x00 0x00 0xFE 0xFF) / ; UTF-32-BE
                        (0xFF 0xFE 0x00 0x00)   ; UTF-32-LE
    encoding_name     = "UTF-8" / ; utf-8 is the default value
                        "UTF-16BE" / "UTF-16LE" /
                        "UTF-32BE" / "UTF-32LE" /
                        "Binary" / 
                        "Windows-1250" / "Windows-1251" / "Windows-1252" /
                        "Windows-1253" / "Windows-1254" / "Windows-1255" /
                        "Windows-1256" / "Windows-1257" / "Windows-1258" /
                        "ISO-8859-1"  / "ISO-8859-2"  / "ISO-8859-3"  /
                        "ISO-8859-4"  / "ISO-8859-5"  / "ISO-8859-6"  /
                        "ISO-8859-7"  / "ISO-8859-8"  / "ISO-8859-9"  /
                        "ISO-8859-10" / "ISO-8859-11" / "ISO-8859-13" /
                        "ISO-8859-14" / "ISO-8859-15" / "ISO-8859-16" /
                        "MacRoman"    / "MacCentEuro" / "MacCroatian" /
                        "MacCyrillic" / "MacGreek"    / "MacIceland"  /
                        "MacRomania"  / "MacThai"     / "MacTurkish"  /
                        "MacUkraine"  / "MacJapanese" /
                        "Big5" / "EUC-JP" / "EUC-KR" / "EUC-TW" / "Shift-JIS"

    newline           = LF / CRLF
    meta_datum        = "% " (meta_record_separator / meta_column_separator /
                        meta_table_name / meta_headers / meta_types) newline

    meta_record_separator = "Record-Separator:" *WSP
                            record_separator_definition
    meta_column_separator = "Column-Separator:" *WSP
                            column_separator_definition
    meta_table_name       = "Name:" *WSP *letter
    meta_headers          = "Headers:" *WSP ("true" / "false"); default is "true"
    meta_types            = "Types:" *WSP ("true" / "false"); default is "false"

    record_separator_definition = "auto-crlf" / ; auto-crlf is the default
                                  "lf" / "crlf" / hex_bytes
    column_separator_definition = "|" / ; "|" is the default
                                  ";" / "," / "tab" / "none" / hex_bytes
    hex_bytes                   = *(2hex)
    hex                         = HEXDIG / "a" / "b" / "c" / "d" / "e" / "f"

    empty_line = *WSP newline
    comment    = *WSP "#" *(letter / WSP) newline

    cell = null | true | false | integer | decimal | currency | float | date |
           datetime | double_quoted_string | single_quoted_string | bare_string

    null                 = "-" / "+null"
    true                 = "+true"
    false                = "+false"
    sign                 = "+" / "-"
    integer              = [sign] (int_b16 / int_b10 / int_b8 / int_b2)
    int_b16              = "0x" 1*hex
    int_b10              = "0" / (%x31-39 1*DIGIT) ; Must not be 0 followed by DIGIT
    int_b8               = "0" 1*(%x30-37) ; "0" to "7"
    int_b2               = "0b" 1*("0" / "1")
    decimal              = [sign] int_b10 "." 1*DIGIT
    currency             = decimal "$"
    float                = decimal "e" decimal
    double_quoted_string = DQUOTE dq_escaped_string DQUOTE
    single_quoted_string = "'" sq_escaped_string "'" ; only \\ and \' are escaped
    dq_escaped_string    = *((%x00-21 / %x23-5b / %x5d-ff) / ("\" OCTET)) ; Everything but \ and "
    sq_escaped_string    = *((%x00-26 / %x28-5b / %x5d-ff) / ("\" OCTET)) ; Everything but \ and '
    date                 = 4DIGIT "-" 2DIGIT "-" 2DIGIT ; YYYY-MM-DD, corresponding to ISO 8601
    time                 = 2DIGIT ":" 2DIGIT [":" 2DIGIT] [offset / "Z"]
    offset               = sign 4DIGIT
    datetime             = date "T" time

    letter           = VCHAR / encoding_letter
    encoding_letter  = ???           ; depends on the document encoding
    column_separator = ???           ; defined within the document
    record_separator = ???           ; defined within the document
    bare_string      = letter *OCTET ; depends on column and record separator
    end_of_document  = ???           ; end of the document


About bare_string
=================

The bare_string type depends on column_separator and record_separator. It may
contain all available characters except the column_separator and the
record_separator.


Important initial defaults
==========================

* Document encoding: Defaults to "UTF-8"
* Column-Separator: Defaults to "|"
* Record-Separator: Defaults to "auto-crlf", which accepts either LF or CRLF
* Headers: defaults to "true"
* Types: defaults to "false"
* Name: defaults to null

Document encoding can only be set ONCE, and MUST be at the very beginning of the document.  
If you set Column-Separator, Record-Separator, Headers, Types - the setting will apply to
all subsequent tables too (is being inherited) until the setting is overridden.
