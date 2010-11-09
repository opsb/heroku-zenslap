# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{opsb-octopussy}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Wynn Netherland", "Adam Stacoviak"]
  s.date = %q{2010-09-01}
  s.description = %q{Simple wrapper for the GitHub API v2}
  s.email = %q{wynn.netherland@gmail.com}
  s.files = ["lib/octopussy/client.rb", "lib/octopussy/event.rb", "lib/octopussy/repo.rb", "lib/octopussy.rb", "test/helper.rb", "test/octopussy_test.rb", "test/repo_test.rb"]
  s.homepage = %q{http://wynnnetherland.com/projects/octopussy/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Wrapper for the Octopussy API}
  s.test_files = ["test/helper.rb", "test/octopussy_test.rb", "test/repo_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hashie>, ["~> 0.2.0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.5.2"])
      s.add_development_dependency(%q<shoulda>, ["~> 2.10.0"])
      s.add_development_dependency(%q<jnunemaker-matchy>, ["= 0.4.0"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.4"])
      s.add_development_dependency(%q<fakeweb>, [">= 1.2.5"])
    else
      s.add_dependency(%q<hashie>, ["~> 0.2.0"])
      s.add_dependency(%q<httparty>, [">= 0.5.2"])
      s.add_dependency(%q<shoulda>, ["~> 2.10.0"])
      s.add_dependency(%q<jnunemaker-matchy>, ["= 0.4.0"])
      s.add_dependency(%q<mocha>, [">= 0.9.4"])
      s.add_dependency(%q<fakeweb>, [">= 1.2.5"])
    end
  else
    s.add_dependency(%q<hashie>, ["~> 0.2.0"])
    s.add_dependency(%q<httparty>, [">= 0.5.2"])
    s.add_dependency(%q<shoulda>, ["~> 2.10.0"])
    s.add_dependency(%q<jnunemaker-matchy>, ["= 0.4.0"])
    s.add_dependency(%q<mocha>, [">= 0.9.4"])
    s.add_dependency(%q<fakeweb>, [">= 1.2.5"])
  end
end
