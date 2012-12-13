require 'rubygems'
require 'spork'
Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rspec'
  require 'capybara/poltergeist'


  Capybara.javascript_driver = :poltergeist
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  DatabaseCleaner[:mongoid].strategy = :truncation

  RSpec.configure do |config|
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true
    config.include Mongoid::Matchers
    config.include Capybara::DSL
    ActiveSupport::Dependencies.clear
  end
end


Spork.each_run do
  Fabrication.clear_definitions
  Dir[File.join(File.dirname(__FILE__), '..', 'app', 'helpers', '*.rb')].each do |file|
    require file
  end
  RSpec.configure do |config|
    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end
