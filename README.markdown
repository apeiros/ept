README
======


Summary
-------

Enhanced Plaintext Tables - better than CSV, with multiple tables per file, datatypes and more.

### Why should you use EPT instead of CSV?

* Multiple tables within a single file
* Explicit declaration of separators (no guessing whether it's ; or , in your parser anymore)
* Explicit declaration whether the first row is a header or not
* Explicit declaration of encoding (no encoding guessing anymore)
* UTF-8 as default encoding
* Typed values (Null, Boolean, Integer, Float, Decimal, Currency, Date, DateTime, String)
* Type annotations for columns
* In-document comments

### What does this library provide?

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

You can use this code under the {file:LICENSE.txt BSD-2-Clause License}, free of charge.
If you need a different license, please ask the author.
