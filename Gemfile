source 'https://rubygems.org/'

group :development, :test do
  gem 'json', :require => false
  gem 'metadata-json-lint', :require => false
  gem 'puppetlabs_spec_helper', :require => false
  gem 'puppet-lint', :require => false
  gem 'rake', :require => false
  gem 'rspec-puppet', :require => false
  gem 'puppet-blacksmith', :require => false
  gem 'rubocop', :require => false
end

if puppetversion = ENV.fetch('PUPPET_GEM_VERSION', '5.3.3')
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
