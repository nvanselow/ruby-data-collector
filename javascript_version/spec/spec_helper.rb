require 'pry'
require 'rspec'
require 'capybara/rspec'
require 'capybara/poltergeist'

require_relative 'support/database_cleaner'
require_relative '../app.rb'

require 'valid_attribute'
require 'shoulda/matchers'

set :environment, :test
set :database, :test

# No ActiveRecord for now.
# ActiveRecord::Base.logger.level = 1

Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.app = Sinatra::Application

# Capybara::Poltergeist::Driver.new Sinatra::Application, {debug: true}

RSpec.configure do |config|
  config.backtrace_exclusion_patterns << /.rubies/
  config.backtrace_exclusion_patterns << /.gem/

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed
end
