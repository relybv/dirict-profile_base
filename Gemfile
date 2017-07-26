source "https://rubygems.org"

group :test do
  gem "rake", '< 11.0'
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || ' > 3.8.0', '< 5.0'
  gem "facter", '2.4.6'
  gem "rspec"
  gem "rspec-puppet"
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'ci_reporter_rspec', '>= 1.0.0'

  gem "puppet-lint-leading_zero-check"
  gem "puppet-lint-trailing_comma-check"
  gem "puppet-lint-version_comparison-check"
  gem "puppet-lint-classes_and_types_beginning_with_digits-check"
  gem "puppet-lint-unquoted_string-check"
  gem 'puppet-lint-resource_reference_syntax'
end

group :development do
  gem "guard-rake"
end

group :system_tests do
#  gem "vagrant-wrapper"
  gem "beaker", '3.18'
  gem "beaker-rspec"
  gem "beaker-puppet_install_helper"
end
