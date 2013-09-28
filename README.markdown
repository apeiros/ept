README
======


Summary
-------

Enhanced Plaintext Tables - better than CSV, with multiple tables per file, datatypes and more.

#### Why should you use EPT instead of CSV?

* Multiple tables within a single file
* Explicit declaration of separators (no guessing whether it's ";", "," or something else)
* Explicit declaration whether the first row is a header or not
* Explicit declaration of encoding (no weird characters like "Ã¤" instead of "ä" anymore)
* UTF-8 as default encoding
* Typed values (Null, Boolean, Integer, Float, Decimal, Currency, Date, DateTime, String)
* Type annotations for columns
* In-document comments

#### What does this library provide?

* A .ept-file parser
* An EPT String parser
* An IO stream parser
* A .ept-file writer
* An EPT String writer
* An IO stream writer


Installation
------------

* Via rubygems: `gem install ept`
* From github: `git clone git@github.com:apeiros/ept.git && cd ept && rm -f *.gem && gem build *.gemspec && gem install *.gem`


Usage
-----

    tables = Ept.read_file('examples/full.ept')


Format of a .ept file
---------------------

A .ept file consists of

* Optional encoding header (must be the first line)
* Comment lines (allowed between and within tables)
* Empty lines between the tables (NOT allowed within tables)
* Tables, with metadata

An example of a minimal .ept file which makes use of defaults:

    First name | Last name | Secret Identity | Born       | Age | Fortune
    Clark      | Kent      | Superman        | 1932-03-26 | 81  | 32_618.00$
    Peter      | Parker    | Spiderman       | 1962-08-15 | 51  |    512.50$

An example of an .ept file which makes use of all features:

    % Encoding: utf-8
    # This is a comment
    % Name: the_table_name
    % Record-Separator: LF
    % Column-Separator: |
    % Headers: true
    % Types: false
    Value type           | Example Value
    Null                 | -
    Null                 | +null
    True                 | +true
    False                | +false
    Integer, base 16     | 0xff99cc
    Integer, base 10     | -291
    Integer, base 8      | 0755
    Integer, base 2      | 0b01001100
    Float                | -4_256.23e15
    Decimal              | 1_235.456
    Currency             | 1_235.60$
    Date                 | 2013-09-31
    Time                 | 12:45:00
    DateTime             | 2013-09-31T12:45:00Z
    Bare String          | Hello world!
    Single Quoted String | 'Hello world!\nBackslash-n'
    Double Quoted String | "Hello world!\nAnother line"

#### Defaults

* Default encoding is utf-8
* Default record separator is LF (linefeed, "\n", 0x0a)
* Default column separator is "|" (0x7c)
* Headers defaults to true
* Types defaults to false
* In ruby, the default name is nil
* In ruby, Null is by default represented by nil
* In ruby, Decimal is by default represented by BigDecimal
* In ruby, Currency is by default represented by BigDecimal
* In ruby, Date is by default represented by Date
* In ruby, Time and DateTime are by default represented by Time


Getting Started
---------------

Take a look at the examples directory.


Caveats
-------

This implementation currently only supports UTF-8 encoding.


Links
-----

* [Online API Documentation](http://rdoc.info/github/apeiros/ept/)
* [Public Repository](https://github.com/apeiros/ept)
* [Bug Reporting](https://github.com/apeiros/ept/issues)
* [RubyGems Site](https://rubygems.org/gems/ept)


License
-------

You can use this code under the [BSD-2-Clause License](LICENSE.txt), free of charge.
If you need a different license, please ask the author.
