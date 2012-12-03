source 'https://rubygems.org'

gem 'rails'
gem 'sqlite3'
gem "mongoid"
gem 'jquery-rails'
gem 'simple_form'
gem 'thin'
gem 'twitter-bootstrap-rails'
gem 'bootstrap-datepicker-rails'
gem 'sorcery'
gem 'jquery-datatables-rails'

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
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'mongoid-rspec'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'rb-inotify', :require => false
  gem 'libnotify' if RUBY_PLATFORM =~ /linux/i
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl' if RUBY_PLATFORM =~ /darwin/i
  gem 'annotate'
end