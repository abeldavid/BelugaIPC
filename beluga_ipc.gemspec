require File.expand_path('lib/beluga_ipc/version', File.dirname(__FILE__))
require 'rake'

Gem::Specification.new do |s|
  s.name = %q{beluga_ipc}
  s.version = BelugaIPC::VERSION
  s.authors = ["Dan Swain"]
  s.date = Time.now.utc.strftime("%Y-%m-%d")
  s.email = %q{dan.t.swain@gmail.com}
  s.files = FileList['lib/**/*.rb', 'bin/*', '[A-Za-z]*',
                     'spec/**/*', 'matlab/*', 'simulator/*',
                     'clients/*'].to_a
  s.executables = Dir.glob("bin/*").map{ |f| File.basename(f) }
  s.homepage = %q{http://github.com/leonard-lab/BelugaIPC}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.8.11}
  s.summary = %q{IPC server for the Beluga project}
  s.test_files = FileList['spec/**/*'].to_a

  # eventually add this back in
  #s.add_dependency "rhubarb"

  # tests
  s.add_development_dependency 'rspec'
end
