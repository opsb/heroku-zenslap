# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{method_lister}
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew O'Connor"]
  s.date = %q{2010-07-12}
  s.email = %q{matthew @nospam@ canonical.org}
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["lib/method_lister/color_display.rb", "lib/method_lister/find_result.rb", "lib/method_lister/finder.rb", "lib/method_lister/ruby_ext.rb", "lib/method_lister/simple_display.rb", "lib/method_lister.rb", "spec/color_display_spec.rb", "spec/find_result_spec.rb", "spec/finder_spec.rb", "spec/helpers/matchers/list_methods.rb", "spec/helpers/object_mother/find_result.rb", "spec/helpers/object_mother/find_scenario.rb", "spec/rcov.opts", "spec/ruby_ext_spec.rb", "spec/scenarios/class_with_inheritance.rb", "spec/scenarios/class_with_inheritance_and_modules.rb", "spec/scenarios/eigenclass.rb", "spec/scenarios/eigenclass_with_modules.rb", "spec/scenarios/filters_results_without_methods.rb", "spec/scenarios/mixed_visibility_methods.rb", "spec/scenarios/object_without_eigenclass.rb", "spec/scenarios/overloaded_methods.rb", "spec/scenarios/overloaded_methods_with_modules_mixed_in.rb", "spec/scenarios/private_methods.rb", "spec/scenarios/single_class.rb", "spec/scenarios/single_class_with_module_mixed_in.rb", "spec/simple_display_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "README.markdown"]
  s.homepage = %q{http://github.com/matthew/method_lister/tree/master}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{method_lister}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Pretty method listers and finders, for use in IRB.}
  s.test_files = ["spec/color_display_spec.rb", "spec/find_result_spec.rb", "spec/finder_spec.rb", "spec/ruby_ext_spec.rb", "spec/simple_display_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
