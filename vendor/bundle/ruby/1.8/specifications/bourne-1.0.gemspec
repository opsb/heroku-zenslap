# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bourne}
  s.version = "1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Joe Ferris"]
  s.date = %q{2010-06-08}
  s.description = %q{Extends mocha to allow detailed tracking and querying of
    stub and mock invocations. Allows test spies using the have_received rspec
    matcher and assert_received for Test::Unit. Extracted from the
    jferris-mocha fork.}
  s.email = %q{jferris@thoughtbot.com}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["lib/bourne/api.rb", "lib/bourne/expectation.rb", "lib/bourne/invocation.rb", "lib/bourne/mock.rb", "lib/bourne/mockery.rb", "lib/bourne.rb", "test/acceptance/acceptance_test_helper.rb", "test/acceptance/mocha_example_test.rb", "test/acceptance/spy_test.rb", "test/acceptance/stubba_example_test.rb", "test/execution_point.rb", "test/matcher_helpers.rb", "test/method_definer.rb", "test/simple_counter.rb", "test/test_helper.rb", "test/test_runner.rb", "test/unit/assert_received_test.rb", "test/unit/expectation_test.rb", "test/unit/have_received_test.rb", "test/unit/invocation_test.rb", "test/unit/mock_test.rb", "test/unit/mockery_test.rb", "LICENSE", "Rakefile", "README"]
  s.homepage = %q{http://github.com/thoughtbot/bourne}
  s.rdoc_options = ["--title", "Bourne", "--main", "README", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Adds test spies to mocha.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>, ["= 0.9.8"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
