# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "library_cal/version"

Gem::Specification.new do |s|
  s.name        = "library_cal"
  s.version     = LibraryCal::VERSION
  s.authors     = ["Andrew Sullivan Cant"]
  s.email       = ["acant@alumni.uwaterloo.ca"]
  s.homepage    = ""
  s.summary     = %q{Convert checked-out item listings for public libraries to ical}
  s.description = %q{A plugable gem which uses Mechanize and Nokogiri to create ical feeds from check-out item listings from public libraries. }

  s.rubyforge_project = "library_cal"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "mechanize"
  s.add_runtime_dependency "icalendar"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "mlightner-require_directory"

  s.add_development_dependency "rspec"
end
