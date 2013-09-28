# encoding: utf-8



require 'ept/version'
require 'ept/parser/document'



# Ept
# Enhanced Plaintext Tables is a potential successor to CSV. This gem allows you to deal with EPT files.
module Ept

  # Parse a .ept file
  def self.read_file(path)
    read_string(File.read(path))
  end

  # Parse a String
  def self.read_string(string)
    ($debug=Ept::Parser::Document.new(string)).parse
  end

  # Parse a Stream, yields the following events:
  def self.read_stream(io, &processor)
    raise "Not implemented"
  end

  def self.tables_to_file(path, tables, options=nil)
    File.write(path, tables_to_string(tables, options))
  end

  def self.table_to_file(path, table, options=nil)
    File.write(path, table_to_string(table, options))
  end

  def self.tables_to_string(tables, options=nil)
    raise "Not implemented"
  end

  def self.table_to_string(tables, options=nil)
    raise "Not implemented"
  end
end
