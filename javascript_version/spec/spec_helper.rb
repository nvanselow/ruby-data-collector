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

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.backtrace_exclusion_patterns << /.rubies/
  config.backtrace_exclusion_patterns << /.gem/

  # config.filter_run focus: true
  # config.run_all_when_everything_filtered = true

  # config.order = :random
  # Kernel.srand config.seed
end

def add_behavior
  fill_in('behavior-name', with: behavior_name)
  fill_in('behavior-key', with: behavior_key)
  fill_in('behavior-description', with: behavior_description)
  click_button('Add Behavior')
end

def fill_out_session_form
  visit '/'

  fill_in('session-duration', with: '5')
  add_behavior

  click_button("Start Session")
end
