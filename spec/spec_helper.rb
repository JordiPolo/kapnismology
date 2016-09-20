require 'combustion'
require 'rspec'
require 'rspec/json_expectations'
require 'byebug'

require 'capybara/rspec'

unless ENV['NO_RAILS']
  Combustion.initialize! :all
  require 'capybara/rails'
end

require 'kapnismology'
require File.expand_path('../support/fake_smoketest', __FILE__)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.allow_message_expectations_on_nil = false
    mocks.syntax = :expect
  end

  config.disable_monkey_patching!

  if ENV['NO_RAILS']
    config.filter_run_excluding :requires_rails
  end

  config.run_all_when_everything_filtered = true

  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random

  Kernel.srand config.seed
end
