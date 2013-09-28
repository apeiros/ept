# encoding: utf-8

Gem::Specification.new do |s|
  s.name                      = "ept"
  s.version                   = "0.0.1"
  s.authors                   = "Stefan Rusterholz"
  s.email                     = "stefan.rusterholz@gmail.com"
  s.homepage                  = "https://github.com/apeiros/ept"
  s.license                   = 'BSD 2-Clause'

  s.description               = <<-DESCRIPTION.gsub(/^    /, '').chomp
    Enhanced Plaintext Tables - better than CSV, with multiple tables per file, datatypes and more.
  DESCRIPTION
  s.summary                   = <<-SUMMARY.gsub(/^    /, '').chomp
    Enhanced Plaintext Tables - better than CSV, with multiple tables per file, datatypes and more.
  SUMMARY

  s.files                     =
    Dir['bin/**/*'] +
    Dir['lib/**/*'] +
    Dir['rake/**/*'] +
    Dir['test/**/*'] +
    Dir['*.gemspec'] +
    %w[
      Rakefile
      README.markdown
    ]

  if File.directory?('bin') then
    s.executables = Dir.chdir('bin') { Dir.glob('**/*').select { |f| File.executable?(f) } }
  end

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1")
  s.rubygems_version          = "1.3.1"
  s.specification_version     = 3
end
