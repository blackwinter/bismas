# -*- encoding: utf-8 -*-
# stub: bismas 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bismas".freeze
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jens Wille".freeze]
  s.date = "2016-06-06"
  s.description = "Access BISMAS databases from Ruby.".freeze
  s.email = "jens.wille@gmail.com".freeze
  s.executables = ["bismas-chardiff".freeze, "bismas-filter".freeze, "bismas2xml".freeze]
  s.extra_rdoc_files = ["README".freeze, "COPYING".freeze, "ChangeLog".freeze]
  s.files = ["COPYING".freeze, "ChangeLog".freeze, "README".freeze, "Rakefile".freeze, "bin/bismas-chardiff".freeze, "bin/bismas-filter".freeze, "bin/bismas2xml".freeze, "lib/bismas.rb".freeze, "lib/bismas/base.rb".freeze, "lib/bismas/cli.rb".freeze, "lib/bismas/cli/chardiff.rb".freeze, "lib/bismas/cli/filter.rb".freeze, "lib/bismas/cli/xml.rb".freeze, "lib/bismas/filter.rb".freeze, "lib/bismas/mapping.rb".freeze, "lib/bismas/parser.rb".freeze, "lib/bismas/reader.rb".freeze, "lib/bismas/schema.rb".freeze, "lib/bismas/version.rb".freeze, "lib/bismas/writer.rb".freeze, "lib/bismas/xml.rb".freeze, "spec/bismas/parser_spec.rb".freeze, "spec/bismas/reader_spec.rb".freeze, "spec/bismas/schema_spec.rb".freeze, "spec/data/test.cat".freeze, "spec/data/test.dat".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "http://github.com/blackwinter/bismas".freeze
  s.licenses = ["AGPL-3.0".freeze]
  s.post_install_message = "\nbismas-0.5.0 [2016-06-06]:\n\n* +bismas2xml+: Learned type +solr+.\n* +bismas2xml+: Learned option +output-encoding+.\n* +bismas2xml+, +bismas-filter+: Learned options +execute-before+ and\n  +execute-after+.\n\n".freeze
  s.rdoc_options = ["--title".freeze, "bismas Application documentation (v0.5.0)".freeze, "--charset".freeze, "UTF-8".freeze, "--line-numbers".freeze, "--all".freeze, "--main".freeze, "README".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0".freeze)
  s.rubygems_version = "2.6.4".freeze
  s.summary = "A Ruby client for BISMAS databases.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cyclops>.freeze, ["~> 0.2"])
      s.add_runtime_dependency(%q<nuggets>.freeze, ["~> 1.5"])
      s.add_development_dependency(%q<hen>.freeze, [">= 0.8.5", "~> 0.8"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<cyclops>.freeze, ["~> 0.2"])
      s.add_dependency(%q<nuggets>.freeze, ["~> 1.5"])
      s.add_dependency(%q<hen>.freeze, [">= 0.8.5", "~> 0.8"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<cyclops>.freeze, ["~> 0.2"])
    s.add_dependency(%q<nuggets>.freeze, ["~> 1.5"])
    s.add_dependency(%q<hen>.freeze, [">= 0.8.5", "~> 0.8"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
