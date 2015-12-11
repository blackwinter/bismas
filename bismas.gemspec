# -*- encoding: utf-8 -*-
# stub: bismas 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bismas"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2015-12-11"
  s.description = "Access BISMAS databases from Ruby."
  s.email = "jens.wille@gmail.com"
  s.executables = ["bismas-chardiff", "bismas-filter", "bismas2xml"]
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "bin/bismas-chardiff", "bin/bismas-filter", "bin/bismas2xml", "lib/bismas.rb", "lib/bismas/base.rb", "lib/bismas/cli.rb", "lib/bismas/cli/chardiff.rb", "lib/bismas/cli/filter.rb", "lib/bismas/cli/xml.rb", "lib/bismas/mapping.rb", "lib/bismas/parser.rb", "lib/bismas/reader.rb", "lib/bismas/schema.rb", "lib/bismas/version.rb", "lib/bismas/writer.rb", "spec/bismas/parser_spec.rb", "spec/bismas/reader_spec.rb", "spec/bismas/schema_spec.rb", "spec/data/test.cat", "spec/data/test.dat", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/blackwinter/bismas"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\nbismas-0.3.0 [2015-12-11]:\n\n* Added +bismas2xml+ executable.\n* Added +bismas-chardiff+ executable.\n* Renamed +bismas+ executable to +bismas-filter+.\n* Renamed Bismas::Categories to Bismas::Schema and extended scope.\n* Fixed Bismas.amend_encoding to use default encoding when encoding option is\n  +nil+.\n* Changed Bismas::Writer to insert key field at beginning of record.\n\n"
  s.rdoc_options = ["--title", "bismas Application documentation (v0.3.0)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0")
  s.rubygems_version = "2.5.1"
  s.summary = "A Ruby client for BISMAS databases."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cyclops>, ["~> 0.2"])
      s.add_runtime_dependency(%q<nuggets>, ["~> 1.4"])
      s.add_development_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<cyclops>, ["~> 0.2"])
      s.add_dependency(%q<nuggets>, ["~> 1.4"])
      s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<cyclops>, ["~> 0.2"])
    s.add_dependency(%q<nuggets>, ["~> 1.4"])
    s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
