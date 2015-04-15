source "https://rubygems.org"

ENV['GEM_PUPPET_VERSION'] ||= ENV['PUPPET_GEM_VERSION']
puppetversion = ENV['GEM_PUPPET_VERSION']
if puppetversion
  gem 'puppet', *location_for(puppetversion)
else
  gem 'puppet', :require => false
end
gem 'puppet-lint'
gem 'rspec-puppet'
gem 'puppetlabs_spec_helper'
gem 'rspec'
