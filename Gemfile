source "https://rubygems.org"

group :test do
  gem "rake", '0.9.6'
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || ' > 3.8.0'
  gem "rspec"
  gem "rspec-puppet"
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
  gem 'rubocop', '0.33.0'
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console'
  gem 'ci_reporter_rspec', '>= 1.0.0'

  gem "puppet-lint-leading_zero-check"
  gem "puppet-lint-trailing_comma-check"
  gem "puppet-lint-version_comparison-check"
  gem "puppet-lint-classes_and_types_beginning_with_digits-check"
  gem "puppet-lint-unquoted_string-check"
  gem 'puppet-lint-resource_reference_syntax'
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "puppet-blacksmith"
  gem "guard-rake"
end

group :system_tests do
  gem "vagrant-wrapper"
  gem "beaker", '3.9'
  gem "beaker-rspec"
  gem "beaker-puppet_install_helper"
end
