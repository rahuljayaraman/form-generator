source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'sqlite3'
gem "mongoid"
gem 'jquery-rails'
gem 'simple_form'
gem 'thin'
gem 'twitter-bootstrap-rails'
gem 'bootstrap-datepicker-rails'
gem 'sorcery'
gem 'jquery-datatables-rails'
gem 'nested_form'
gem 'jquery-ui-rails'
gem 'resque', :require => 'resque/server'
gem 'resque_mailer'
gem 'unicorn'
gem 'capistrano'
gem 'rvm-capistrano'
gem 'roo'
gem 'google-spreadsheet-ruby'

group :assets do
  gem 'less-rails'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer', :platforms => :ruby
end

group :test do
  gem 'spork'
  gem 'faker'
  gem 'capybara', '~> 1.1.0'
  gem 'launchy'
  gem 'fabrication'
  gem 'database_cleaner'
  gem 'mongoid-rspec'
  gem 'poltergeist'
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'rb-inotify', :require => false
  gem 'libnotify' if RUBY_PLATFORM =~ /linux/i
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl' if RUBY_PLATFORM =~ /darwin/i
  gem 'annotate'
end
