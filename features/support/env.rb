require 'coveralls'
require 'simplecov'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
Coveralls.wear_merged!
require 'rack/test'
require 'cucumber/rails'
require 'capybara/poltergeist'
require 'webmock/cucumber'

Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 5
WebMock.allow_net_connect!


ActionController::Base.allow_rescue = false

DatabaseCleaner.strategy = :truncation

Cucumber::Rails::Database.javascript_strategy = :truncation

# Something is setting request.host to 'example.org', so the step definitions
# need that set too
Before { host! 'example.org' }


World(Rack::Test::Methods)
