# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{frequency-dsl}
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tiago Peczenyj"]
  s.date = %q{2010-05-20}
  s.description = %q{A small dsl written in ruby to work with frequency events (never, sometimes, always..)}
  s.email = %q{tiago.peczenyj@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "frequency-dsl.gemspec",
     "lib/frequency.rb",
     "rdoc/classes/Frequency.html",
     "rdoc/created.rid",
     "rdoc/files/README_rdoc.html",
     "rdoc/files/lib/frequency_rb.html",
     "rdoc/fr_class_index.html",
     "rdoc/fr_file_index.html",
     "rdoc/fr_method_index.html",
     "rdoc/index.html",
     "rdoc/rdoc-style.css",
     "spec/frequency_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/peczenyj/Frequency}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A small dsl written in ruby to work with frequency events}
  s.test_files = [
    "spec/frequency_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end

